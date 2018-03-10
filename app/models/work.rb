class Work < ApplicationRecord
  belongs_to :mechanic
  belongs_to :skill
  def skill_name
    skill.name 
  end
 def skill_name_price
    name = []
    name << skill.name  if skill 
    name << price if price
    name.join(" ")
  end
  def set_price
    Work.all.each do |work|
      @work=work
      if(@work.price.blank?)
        @order = Order.where("mechanic_id = ? AND skill_cd = ? AND quantity>0", @work.mechanic_id, @work.skill_id).last
        unless( @order.nil?)
          temp_quantity=@order.quantity
          @work.price = @order.mechanic_income / temp_quantity if @order.mechanic_income>0
          @work.save
        end
      end
    end 
  end 

  def add_price
    Work.where("skill_id=28").each do |work|
      @work_28=work
        @work_haved=Work.where("mechanic_id = ? AND skill_id = ? ",@work_28.mechanic_id,146).last
        if(@work_haved.nil?)
          @work=Work.new
          @work.mechanic_id=@work_28.mechanic_id
          @work.skill_id=146
          @work.price = 20
          @work.save
        end
    end 
  end

  def set_work

    Order.availables.where("quantity>0 and mechanic_id>0 and skill_cd>0 and id>66912").each do |order|
      @order=order
      temp_quantity=@order.quantity
      @work=Work.where("mechanic_id = ? AND skill_id = ? ",@order.mechanic_id,@order.skill_cd).last
      if(@work.nil?)
          @work=Work.new
          @work.mechanic_id=@order.mechanic_id
          @work.skill_id=@order.skill_cd
          @work.price = @order.mechanic_income / temp_quantity if @order.mechanic_income>0
          @work.save
      else
        if(@work.price.blank?)
          @work.price = @order.mechanic_income / temp_quantity if @order.mechanic_income>0
          @work.save
        end
      end
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
        44 #dev 37,production 44
    when "TN"
        34
    when "JZD"
        42
    when "JZS"
        41
    when "H" 
        52
    when "QSCP"
        48
    when "ZSCP"
        49
    when "TZZ"
        1
    when "DZ"
        2
    when "JZZ"
        9  
    when "DSCP"
        55 
    when "BXG"
        135 
    when "CTB"
        90 
    when "BJPQ"
        129      
    when "XC"
        131  
    when "SZDW"
        68
    when "zt"
        107
    when "zd"
        36
    when "jd"
        125        
    else
        0
    end
  end
  
  def set_price_by_description
    TempMechanic.all.each do |temp_mechanic|
      
      temp_mechanic.description_hash.each do |key,value|
      _skill_id=get_skill_id key
      
      @work = Work.where("mechanic_id = ? AND skill_id = ?", temp_mechanic.mechanic_id, _skill_id).last
        if(@work.nil?)
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

  def set_mechanic_group_id
    Mechanic.where("id<200").each do |mechanic|
      @mechanic=mechanic
      @mechanic.works.each do |work|
        @work=work
        if(@work.skill.present?)
          group_id="#{@work.skill.group_id},"
          if @mechanic.group_id.nil?
            @mechanic.group_id=group_id
          else
            @mechanic.group_id<<group_id if @mechanic.group_id.index(group_id).nil?
          end
        end
      end
      @mechanic.save unless @mechanic.group_id.nil?
    end
    
  end  

  
end
