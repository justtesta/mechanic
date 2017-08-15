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
  def get_skill_id (key)
    case key
    when "M"
        29
    when "L"
        28
    when "Y"
        39
    when "DJ"
        15
    when "TW"
        37
    when "TN"
        34
    when "JLD"
        42
    when "JLS"
        41
    else
        0
    end
  end
  
  def set_price_by_description
    TempMechanic.all.each do |temp_mechanic|
      byebug
      temp_mechanic.description_hash.each do |key,value|
      _skill_id=get_skill_id key
      @work = Work.where("mechanic_id = ? AND skill_id = ?", temp_mechanic.mechanic_id, _skill_id).last
        if(@work.nil)
          @work=Work.new
          @work.mechanic_id=temp_mechanic.mechanic_id
          @work.skill_id=_skill_id
          @work.price = value  unless  value.nil?
          @work.save
        else
          if(@work.price.blank?)
          @work.price = value  unless  value.nil?
          @work.save
          end
       end
     end
     
    end 
  end 

  
end
