class AddWithdrawalRemarkToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :withdrawal_remark, :string
  end
end
