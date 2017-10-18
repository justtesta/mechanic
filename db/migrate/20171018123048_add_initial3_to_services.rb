class AddInitial3ToServices < ActiveRecord::Migration[5.0]
  def change
  	Service.create(name: "打蜡服务")
  end
end
