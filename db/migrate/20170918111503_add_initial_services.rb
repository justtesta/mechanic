class AddInitialServices < ActiveRecord::Migration[5.0]
  def change
  	Service.create(name: "暂停服务")
  	
  end
end
