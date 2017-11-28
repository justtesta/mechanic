class Admin::MechanicsController < Admin::ApplicationController
  before_action :find_mechanic, except: [ :index, :new, :create, :import, :create_import ]

  def index
    @state = if %w(all hidden shown reg userupdate).include? params[:state]
        params[:state].to_sym
      else
        :all
      end
    if params[:user_group]
      @user_group = UserGroup.find params[:user_group]
      @mechanics = @user_group.users
    else
      @mechanics = User.mechanics.send(@state)
    end
  end
  
  def edit
  
  end


  def clientize
    @mechanic.client!
    if @mechanic.save
      redirect_to admin_user_path(@mechanic)
    else
      flash[:error] = "帐号信息不完整，无法转换"
      redirect_to_referer!
    end
  end

  def new
    @mechanic = User.new
    @mechanic.build_mechanic
  end

  def create
    
    @mechanic_params=mechanic_params
    @mechanic_params[:mechanic_attributes].delete :skills
    @mechanic = User.new(@mechanic_params)
    @mechanic.mechanic!
    if @mechanic.save
      works = Array.new
      mechanic_params[:mechanic_attributes][:skills].each{ |work|
      if work[:is_checked]=="1"
        work.delete :is_checked
        works << @mechanic.mechanic.works.new(work) unless work[:skill_id].empty?
      end
      }
      @mechanic.mechanic.works.push(works)
      redirect_to admin_mechanics_path
    else
      render :new
    end
  end

  def update
  
    works = Array.new
    mechanic_params[:mechanic_attributes][:skills].each{ |work|
      if work[:is_checked]=="1"
        work.delete :is_checked
        works << @mechanic.mechanic.works.new(work) unless work[:skill_id].empty?
      end
    }
    @mechanic_params=mechanic_params
    @mechanic_params[:mechanic_attributes].delete :skills
    @mechanic_params[:mechanic_attributes][:works]=[]
    if @mechanic.update_attributes(@mechanic_params)
      #@mechanic.mechanic.works.clear
      @mechanic.mechanic.works.push(works)
      redirect_to admin_mechanics_path
    else
      render :new
    end
  end

  def hide
    @mechanic.hide!
    redirect_to_referer!
  end

  def unhide
    @mechanic.unhide!
    redirect_to_referer!
  end

  def hidereg
    @mechanic.update_attribute(:fromsource, "")
    redirect_to_referer!
  end

  def hideupdate
    @mechanic.update_attribute(:userupdate, false)
    redirect_to_referer!
  end


  def create_import
    file = params[:import][:mechanics]
    @importer = Mechanic::Importer.new(file)
  end

  private

    def find_mechanic
      @mechanic = User.find(params[:id])
    end

    def mechanic_params
      params.require(:user).permit(:mobile, :nickname, :gender, :address, :weixin_openid,:withdrawal_remark,
        mechanic_attributes: [ :unique_id, :province_cd, :description, :city_cd, :district_cd, :linkman, :service_staff, skills: [[:is_checked, :price, :skill_id]], service_ids: []  ])
    end

end
