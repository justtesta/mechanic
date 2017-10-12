class AddInitial2ToServices < ActiveRecord::Migration[5.0]
  def change
  	Service.create(name: "一元引流")
  end
end
