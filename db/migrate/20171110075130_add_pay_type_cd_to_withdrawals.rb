class AddPayTypeCdToWithdrawals < ActiveRecord::Migration[5.0]
  def change
    add_column :withdrawals, :pay_type_cd, :integer, default: 0
  end
end
