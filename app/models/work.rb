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
end
