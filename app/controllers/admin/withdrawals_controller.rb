class Admin::WithdrawalsController < Admin::ApplicationController
  before_action :redirect_user
  before_action :find_withdrawal, except: [ :index, :settings, :update_settings ]

  def index
    @state = if %w(all pendings).include? params[:state]
        params[:state].to_sym
      else
        :pendings
      end
    
    @withdrawals = Withdrawal.send(@state)
   
  end

  def confirm
    if @withdrawal.pending?
      response = Weixin.withdrawal @withdrawal
      if response.success?
        @withdrawal.pay!
      else
        flash[:error] = "微信支付：#{response["err_code_des"]}"
      end
    else
      flash[:error] = "订单状态错误！"
    end
    redirect_to_referer!
  end
  
  def confirm_nopay
    if @withdrawal.pending?
       @withdrawal.pay!
    else
      flash[:error] = "订单状态错误！"
    end
    redirect_to_referer!
  end

  def cancel
    if @withdrawal.pending?
      @withdrawal.cancel!
    else
      flash[:error] = "订单状态错误！"
    end
    redirect_to_referer!
  end

  def message
    if @withdrawal.pending?
      @withdrawal.message
      flash[:success] = "已发送微信模板消息！"
    else
      flash[:error] = "提现状态错误！"
    end
    redirect_to_referer!
  end

  def update_settings
    ActiveRecord::Base.transaction do
      setting_params.each do |key, value|
        ::Setting[key] = value
      end
    end
    redirect_to settings_admin_withdrawals_path
  end

  private

    def find_withdrawal
      @withdrawal = Withdrawal.find(params[:id])
    end

    def setting_params
      params.require(:setting).permit(:commission_percent, :mobile_commission_percent,
        :client_commission_percent, :mechanic_commission_percent)
    end
end
