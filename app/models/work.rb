class Work < ApplicationRecord
  belongs_to :mechanic
  belongs_to :skill
  def skill_name
    skill.name + " 价格：" + price
  end
end
