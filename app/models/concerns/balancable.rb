module Balancable
  extend ActiveSupport::Concern

  included do
    attr_accessor :balance_update_amount, :balance_update_description
  end

  def increase_balance! amount, reason = "", source = nil
    if amount >= 0
      update_balance!(amount, reason, source)
    else
      errors.add :balance_update_amount, :invalid
      false
    end
  end

  def decrease_balance! amount, reason = "", source = nil
    if amount >= 0
      update_balance!(-amount, reason, source)
    else
      errors.add :balance_update_amount, :invalid
      false
    end
  end

  def update_balance! amount, reason = "", source = nil
    if reason.present?
      Metric.audit self, source, :balance, reason: reason, amount: amount
      increment!(:balance, amount)
      true
    else
      errors.add :balance_update_description, :blank
      self.balance_update_amount = amount
      self.balance_update_description = reason
      false
    end
  end

  def clear_balance
    if(balance>0)
      amount=0-balance
      update_balance! amount, "管理清零"
    end
  end

end
