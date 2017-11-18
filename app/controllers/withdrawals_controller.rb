class WithdrawalsController < ApplicationController
  before_action :find_withdrawals_by_state
  before_action :current_weixin_openid!, only: [ :new]

  helper_method :withdrawal_klass


  def new
    @withdrawal = withdrawal_klass.new
    @withdrawal.current_weixin_openid = @openid
  end

  def create
    @withdrawal = withdrawal_klass.new(withdrawal_params)
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
      params.require(:withdrawal).permit(:amount,:current_weixin_openid)
    end

    def current_weixin_openid!
      if request.get? && weixin? && current_user 
        if params.key? "code"
          @openid = Weixin.get_oauth_access_token(params["code"]).result["openid"]
        else
          redirect_to Weixin.authorize_url(request.url)
        end
      end
    end
end
