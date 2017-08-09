class Work < ApplicationRecord
  belongs_to :mechanic
  belongs_to :skill
  def skill_name
    skill.name 
  end
 def skill_name_price
    name = []
    name << skill.name  if skill.name 
    name << price if price
    name.join(" ")
  end
  def set_price
   @order = Order.where("mechanic_id = ? AND skill_cd = ?", mechanic_id, skill_id).last
   if(price.blank?)
     send("price=",  @order.price) unless  @order.price.blank?
   end
  end 
  
end
