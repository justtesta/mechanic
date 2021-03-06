class UsersController < ApplicationController
  before_action :validate!, except: [ :new, :create ]
  before_action :find_user, only: [ :new, :create, :edit, :update, :photo, :update_photo, :holiday, :update_holiday ]

  def new
    @user.build_mechanic unless @user.mechanic
  end

  def create
    if @user.update_attributes(user_params)
      redirect! :authenticate, root_path
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      @user.update_attribute(:userupdate, true)
      redirect_to user_path
    else
      render :edit
    end
  end

  def update_photo
    if @user.update_attributes(update_photo_user_params)
      @user.update_attribute(:userupdate, true)
      redirect_to photo_user_path
    else
      render :photo
    end
  end

  def update_holiday
    if @user.update_attributes(update_holiday_user_params)
      flash[:notice] = "春节放假时间更新成功！"
      @user.update_attribute(:userupdate, true)
      redirect_to holiday_user_path
    else
      render :holiday
    end
  end

  private

    def find_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:mobile, :nickname, :gender, :address, :avatar,
        mechanic_attributes: [:_create, :id, :province_cd, :city_cd, :district_cd, 
        skill_cds: [], service_ids: [] ])
    end

    def update_photo_user_params
      params.require(:user).permit(mechanic_attributes: [:mechanic_attach_1, :mechanic_attach_2, :mechanic_attach_3,:mechanic_attach_4,:mechanic_attach_5,:mechanic_attach_1_media_id, :mechanic_attach_2_media_id, :mechanic_attach_3_media_id, :mechanic_attach_4_media_id, :mechanic_attach_5_media_id])
    end

    def update_holiday_user_params
      params.require(:user).permit(mechanic_attributes: [:holiday_start, :holiday_end, service_ids: []])
    end

    def authenticate!
      if !current_user_session || !current_user
        set_redirect_original_url :authenticate
        redirect_to new_user_session_path
      else
        clear_redirect :authenticate
      end
    end

    def validate!
      if current_user.invalid?
        set_redirect_original_url :authenticate
        redirect_to new_user_path
      else
        clear_redirect :authenticate
      end
    end
end
