class AddInitial7ToServices < ActiveRecord::Migration[5.0]
  def change
  	Service.create(name: "春节无休")
  end
end
