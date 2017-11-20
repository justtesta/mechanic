class WithdrawalsController < ApplicationController
  before_action :find_withdrawals_by_state
  before_action :current_weixin_openid!, only: [ :new]

  helper_method :withdrawal_klass


  def new
    @withdrawal = withdrawal_klass.new
     
  end

  def create
    
    @withdrawal = withdrawal_klass.new(withdrawal_params)
    
    if @withdrawal.user.systempay_count<3
       _mobile = params[:withdrawal][:mobile]
      if(_mobile.blank?)
        flash[:error] = "提现失败：预留手机不能为空！"
        render :new
        return false
      end
      if(_mobile!=@withdrawal.user.mobile)
        flash[:error] = "提现失败：与预设的负责人手机号不符！预设的手机号为#{@withdrawal.out_left_mobile},您填写的为#{_mobile}"
        render :new
        return false
      end
    end

    _current_weixin_openid = params[:withdrawal][:current_weixin_openid]
    if(_current_weixin_openid!=@withdrawal.user.weixin_openid)
      flash[:error] = "提现失败：当前微信不是预设的提现到帐微信,请使用首次绑定的微信提现！如果因为网页打开过长时间或缓存，请重新进入面页。当前微信#{_current_weixin_openid}，提现微信#{@withdrawal.user.weixin_openid[0,10]}"
      render :new
      return false
    end

    if @withdrawal.save
      flash[:success] = "提现申请已提交，等待管理员审核..."
      redirect_to user_path
    else
      render :new
    end
  end

  private

    def find_withdrawals_by_state
      @state = if %w(pendings paids canceleds).include? params[:state]
          params[:state].to_sym
        else
          :pendings
        end
      @withdrawals = withdrawal_klass.send(@state)
    end

    def withdrawal_klass
      Withdrawal.where(user_id: current_user)
    end

    def withdrawal_params
      params.require(:withdrawal).permit(:amount)
    end

    def current_weixin_openid!
      if(session[:openid].present?)
          @openid = session[:openid]
      else
          session[:openid] ="ddd"
      end
      if request.get? && weixin? && current_user 
        if(session[:openid].present?)
          @openid = session[:openid]
        else
          if params.key? "code"
            @openid = Weixin.get_oauth_access_token(params["code"]).result["openid"]
            session[:openid] = @openid 
          else
            redirect_to Weixin.authorize_url(request.url)
          end
        end
      end
    end
end
