class Order < ApplicationRecord
  module State
    extend ActiveSupport::Concern

    included do

      AVAILABLE_GREATER_THAN = 5
      SETTLED_GREATER_THAN = 8
      DONE_GREATER_THAN  = 7

      as_enum :state, pending: 0, paying: 1, pended: 2, canceled: 3, refunding: 4, refunded: 5,
        paid: 6, working: 7, confirming: 8, finished: 9, reviewed: 10, closed: 11
      as_enum :cancel, pending_timeout: 0, paying_timeout: 1, user_abstain: 2, user_cancel: 3
      as_enum :refund, user_cancel: 0, merchant_revoke: 1, admin_freeze: 2
      as_enum :confirm_type,none: 0, confirm_no_withdrawal: 1, confirm: 2, withdrawal: 3, before_withdrawal: 4,before_confirm_no_withdrawal:5
      as_enum :pay_type, { weixin: 0, alipay: 1, skip: 2, balance: 3 }, prefix: true

      scope :availables, -> { where('"orders"."state_cd" > ?', AVAILABLE_GREATER_THAN) }
      def available?
        state_cd > AVAILABLE_GREATER_THAN
      end

      scope :settleds, -> { where('"orders"."state_cd" > ?', SETTLED_GREATER_THAN) }
      def settled?
        state_cd > SETTLED_GREATER_THAN
      end

      scope :dones, -> { where('"orders"."state_cd" > ?', DONE_GREATER_THAN) }
      def done?
        state_cd > DONE_GREATER_THAN
      end

      scope :last_availables, -> { where('"orders"."state_cd" > ? And created_at> ?', AVAILABLE_GREATER_THAN,-3.months.from_now ) }
      scope :last_dones, -> { where('"orders"."state_cd" > ? And created_at> ?', DONE_GREATER_THAN,-3.months.from_now) }

      scope :state_scope, -> (state) { where(state_cd: states.value(state)) }

      def update_state to
        update_attribute(:state, Order.states[to])
        #Rails.logger.info "  Order##{id} state change: from :#{state} to :#{to}"
      end

      def pend!
        return false unless paying?
        update_state(:pended)
        true
      end

      def pending!
        SendCreateOrderMessageJob.set(wait: 1.second).perform_later(self)
        UpdateOrderStateJob.set(wait: PendingTimeout).perform_later(self)
        true
      end

      def pick! target = nil
        return false unless pending?
        update_state(:paying)
        UpdateOrderStateJob.set(wait: PayingTimeout).perform_later(self)

        # target could be a bid or a mechanic
        case target
        when Bid
          self.bid_id = target.id
          self.mechanic_id = target.mechanic_id
          self.markup_price = target.markup_price
        when Mechanic
          self.mechanic_id = target.id
        end

        pay! :skip if offline?
        save(validate: false)
        true
      end

      def repick! mechanic,repick_merchant_id=0,_repick_by_merchant_name=nil
        # Only available and non-setted orders can repick mechanic
        return false unless state_cd > AVAILABLE_GREATER_THAN && state_cd <= SETTLED_GREATER_THAN
        original_mechanic = self.mechanic
        update_state(:paid)
        update_attribute(:mechanic, mechanic)
        update_attribute(:repick_by, repick_merchant_id)
        update_attribute(:repick_by_merchant_name, _repick_by_merchant_name)
        Weixin.send_pay_order_message(self)
        SMS.send_pay_order_message(self)

        if original_mechanic && mechanic != original_mechanic
          Weixin.send_refund_order_message(self, original_mechanic)
          SMS.send_refund_order_message(self, original_mechanic)
        end

        true
      end

      def automatic_repick!
        return false unless paid?
        return false unless unassigned?
        return false unless selected?
        return false if automatic?
        return false unless self.skill_cd==28||self.skill_cd==29||self.skill_cd==42||self.skill_cd==9 ||self.skill_cd==34||self.skill_cd==44
        return false if  self.pre_procedure_price.to_i >= self.quoted_price
        return false unless  self.pre_procedure_price.to_i > 0
        mechanic = Mechanic.find(self.selectmechanic_id)
        return false unless mechanic.skilled_dones_orders(self.skill_cd).count>0
        return false if mechanic.user.hidden?
        update_attribute(:remark, self.pre_remark) if self.pre_remark
        update_attribute(:procedure_price, self.pre_procedure_price) if self.pre_procedure_price       
        repick! mechanic,0,"自动派单"
        update_attribute(:automatic, true)
      end


      def cancel! reason = :user_cancel
        return false unless pending? || paying? || pended?
        update_attribute(:cancel, Order.cancels[reason])
        update_state(:canceled)
        true
      end

      def pay! pay_type = :weixin, trade_no = nil
        return false unless paying? || pended? || canceled?

        if pay_type == :balance
          if price > store.balance
            errors.add(:base, "店铺余额不足")
            return false
          else
            store.decrease_balance! price, "订单支付", self
          end
        end

        update_attribute(:pay_type, Order.pay_types[pay_type])
        update_attribute(:trade_no, trade_no) if trade_no
        update_state(:paid)
        user.increase_total_cost!(price)

        if mechanic
          Weixin.send_pay_order_message(self)
          SMS.send_pay_order_message(self)
        end

        true
      rescue => error
        Rails.logger.error "#{error.class}: #{error.message} from Order#pay!"
      end

      def refunding! reason = :user_cancel
        return false unless paid? || merchant? && (working? || confirming?)
        update_attribute(:refund_at, Time.now)
        update_attribute(:refund, Order.refunds[reason])
        update_state(:refunding)

        if mechanic
          Weixin.send_refund_order_message(self, mechanic)
          SMS.send_refund_order_message(self, mechanic)
        end

        true
      end

      def refund! reason = :user_cancel
        return false unless refunding? || paid? || merchant? && (working? || confirming?)
        not_yet_send_refund_order_message = !refunding?

        if pay_type == :balance
          store.increase_balance! price, "订单退款", self
        end

        update_attribute(:refund, Order.refunds[reason]) unless refunding?
        update_state(:refunded)
        user.increase_total_cost!(-price)

        if mechanic && not_yet_send_refund_order_message
          Weixin.send_refund_order_message(self, mechanic)
          SMS.send_refund_order_message(self, mechanic)
        end

        true
      end

      def freeze!
        return false unless refunding?

        update_attribute(:refund, Order.refunds[:admin_freeze])
        update_state(:refunded)

        true
      end

      def work!
        return false unless paid?
        update_attribute(:start_working_at, Time.now)
        update_state(:working)
        true
      end

      def finish!
        if(confirming?) then
          errors.add(:base, "该订单已提交审核，请查看审核中的订单，等待管理员审核")
          return false
        end
        if(finished?) then
          errors.add(:base, "该订单已确认完工。")
          return false
        end
        unless(working?||paid?) then
          errors.add(:base, "订单状态不对，是否已经由客服确认完工")
          return false
        end
        if !mobile? && !mechanic_attach_1.present?
          errors.add(:mechanic_attach_1, "网页端派单请上传车主短信照片")
          return false
        end
        update_state(:confirming)
        UpdateOrderStateJob.set(wait: ConfirmingTimeout).perform_later(self)
        Weixin.send_confirm_order_message self
        true
      rescue => error
        Rails.logger.error "#{error.class}: #{error.message} from Order#finish!"
      end

      def confirm! confirm_merchant_id=0,_confirm_by_merchant_name=nil
          return false unless confirming?||working?||paid?
          return false unless assigned?
          return false unless ConfirmOrder.create(order_id: self.id).valid?
          update_attributes({:state=>Order.states[:finished],:finish_working_at=>Time.now,:confirm_type=>Order.confirm_types[:before_confirm_no_withdrawal],:confirm_by=>confirm_merchant_id,:confirm_by_merchant_name=>_confirm_by_merchant_name})
        unless offline?
          # Increase balance
          mechanic.user.increase_balance!(mechanic_income, "订单结算", self)
=begin
          if client_user_group = user.user_group
            client_user_group.user.increase_balance!(client_commission, "订单分红", self)
          end

          if mechanic_user_group = mechanic.user_group
            mechanic_user_group.user.increase_balance!(mechanic_commission, "订单分红", self)
          end
=end
        end

        # Increase total income / commission
        mechanic.increase_total_income!(mechanic_income)
=begin
        if client_user_group = user.user_group
          client_user_group.increase_total_commission!(client_commission)
        end

        if mechanic_user_group = mechanic.user_group
          mechanic_user_group.increase_total_commission!(mechanic_commission)
        end
=end
        true
      end

      def automatic_confirm!
        return false if offline?
        return false unless self.mechanic.self_withdrawal?
        return false if self.numbers.checked_numbers.count==0
        return false if self.numbers.unchecked_numbers.count>0 
        return false if self.hosting_remark.present?
        if confirm! 0,"自动确认"
          update_attributes({:automatic_confirm=>true,:confirm_type=>Order.confirm_types[:confirm_no_withdrawal]})
        end
      end

      def withdrawal! confirm_merchant_id=0,_confirm_by_merchant_name=nil
          return false unless confirming?||working?||paid?
          return false unless assigned?
          return false unless ConfirmOrder.create(order_id: self.id).valid?
          update_attributes({:state=>Order.states[:finished],:finish_working_at=>Time.now,:confirm_type=>Order.confirm_types[:before_withdrawal],:confirm_by=>confirm_merchant_id,:confirm_by_merchant_name=>_confirm_by_merchant_name})

        unless offline?
          # Increase balance
          mechanic.user.increase_balance!(mechanic_income, "订单结算", self)
          @withdrawal=Withdrawal.create(user_id: mechanic.user_id, amount: mechanic_income,state_cd: Withdrawal.states[:paid], pay_type_cd: Withdrawal.pay_types[:manual] )
          update_attribute(:confirm_type, Order.confirm_types[:withdrawal])
         

          #if client_user_group = user.user_group
          #  client_user_group.user.increase_balance!(client_commission, "订单分红", self)
          #end

          #if mechanic_user_group = mechanic.user_group
          #  mechanic_user_group.user.increase_balance!(mechanic_commission, "订单分红", self)
          #end
        end

        # Increase total income / commission
        mechanic.increase_total_income!(mechanic_income)

        #if client_user_group = user.user_group
        #  client_user_group.increase_total_commission!(client_commission)
        #end

        #if mechanic_user_group = mechanic.user_group
        #  mechanic_user_group.increase_total_commission!(mechanic_commission)
        #end
        true

      
      end

      def rework!
        return false unless confirming?
        update_state(:working)
        Weixin.send_rework_order_message self
        true
      rescue => error
        Rails.logger.error "#{error.class}: #{error.message} from Order#rework!"
      end

      def review!
        update_attribute(:reviewed_at, Time.now)
        update_state(:reviewed)
        true
      end

      def close!
        return false unless reviewed?
        update_attribute(:closed_at, Time.now)
        update_state(:closed)
        true
      end
    end

  end
end
