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
    Work.all.each do |work|
    @work=work
    @order = Order.where("mechanic_id = ? AND skill_cd = ?", @work.mechanic_id, @work.skill_id).last
     # if(@work.price.blank?)
      @work.price = @order.mechanic_income  unless  @order.nil?
      @work.save
     # end
    end 
  end 
  
end
