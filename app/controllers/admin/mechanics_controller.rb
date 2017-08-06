class Admin::MechanicsController < Admin::ApplicationController
  before_action :find_mechanic, except: [ :index, :new, :create, :import, :create_import ]

  def index
    @state = if %w(all hidden shown reg).include? params[:state]
        params[:state].to_sym
      else
        :all
      end
    @mechanics = User.mechanics.send(@state)
  end
  
  def edit
  #@article=Article.find(params[:id])
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
    @mechanic = User.new(mechanic_params)
    @mechanic.mechanic!
    if @mechanic.save
      redirect_to admin_mechanics_path
    else
      render :new
    end
  end

  def update
  
    works = Array.new
    byebug
    mechanic_params[:mechanic_attributes][:skills].each{ |work|
      if work[:is_checked]==1
        work.delete :is_checked
        byebug
      works << @mechanic.mechanic.works.new(work) unless work[:skill_id].empty?
      end
    }
    mechanic_params[:mechanic_attributes].delete :skills
    if @mechanic.update_attributes(mechanic_params)
      byebug
      @mechanic.mechanic.works.replace(works)
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

  def create_import
    file = params[:import][:mechanics]
    @importer = Mechanic::Importer.new(file)
  end

  private

    def find_mechanic
      @mechanic = User.find(params[:id])
    end

    def mechanic_params
      params.require(:user).permit(:mobile, :nickname, :gender, :address, :weixin_openid,
        mechanic_attributes: [ :unique_id, :province_cd, :city_cd, :district_cd, :description, skills: [[:is_checked, :price, :skill_id]] ])
    end

end
