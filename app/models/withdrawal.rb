class Withdrawal < ApplicationRecord
  belongs_to :user

  as_enum :state, pending: 0, canceled: 1, paid: 2
  as_enum :pay_type,none: 0, system: 8, manual: 9
     

  after_create do
    user.decrease_balance!(amount, "申请提现", self)
  end

  validates_numericality_of :amount, greater_than_or_equal_to: 1
  validates_presence_of :amount
  validate :validate_amount

  scope :pendings, -> { where(state_cd: states.value(:pending)) }
  
  delegate :nickname, :mobile, :address, :weixin_openid, to: :user, prefix: true, allow_nil: true

  def validate_amount
    errors.add(:base, "账户余额不足") if amount && amount > user.balance
  end

  def pay! withdrawal_pay_type
    return false unless pending?
    update_attribute(:state, Withdrawal.states[:paid])
    update_attribute(:pay_type_cd, Withdrawal.pay_types[withdrawal_pay_type])
    self.user.update_attribute(:systempay,true) if(withdrawal_pay_type==:system)
  end

  def cancel!
    return false unless pending?
    user.increase_balance!(amount, "取消提现", self)
    update_attribute(:state, Withdrawal.states[:canceled])
  end

  def message
    return false unless pending?
    Weixin.send_confirm_withdrawal_message(self)
  end

  def title
    "#{user.nickname} 申请提现 #{amount} 元"
  end

  def update_timestamp column, update, force
    if force || (!send(column) && update)
      update_attribute(column, Time.now)
    end
  end

  def out_trade_no force = false
    update_timestamp :paid_at, true, force
    "#{paid_at.strftime("%Y%m%d")}#{"%06d" % id}"
  end

  def current_weixin_openid
    "11"
  end

  def mobile    
  end

  def left_mobile
    self.user.mobile[0,6]
  end

  def out_left_mobile
    "#{left_mobile}*****"
  end
end
