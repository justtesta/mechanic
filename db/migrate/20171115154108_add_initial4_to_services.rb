class AddInitial4ToServices < ActiveRecord::Migration[5.0]
  def change
  	Service.create(name: "京东优选")
  end
end
