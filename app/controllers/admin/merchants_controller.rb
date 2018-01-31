class Admin::MerchantsController < Admin::ApplicationController
  before_action :redirect_user
  before_action :find_merchant, except: [ :index, :confirmed ]

  def index
    @merchants = Store.merchants.unconfirmeds
  end

  def confirmed
    @confirmed = true
    @merchants = Store.merchants.confirmeds
  end

  def confirm
    @merchant.confirm!
    redirect_to_referer!
  end

  def active
    @merchant.active!
    redirect_to_referer!
  end

  def inactive
    @merchant.inactive!
    redirect_to_referer!
  end

  def destroy
    @merchant.destroy
    redirect_to_referer!
  end

  def update_settings
    ActiveRecord::Base.transaction do
      settings = @merchant.settings
      params = setting_params
      use_system_commission_percent = params.delete :use_system_commission_percent
      if ["0", 0, false].include? use_system_commission_percent
        settings[:use_system_commission_percent] = false
        params.each do |key, value|
          settings[key] = value
        end
      else
        settings[:use_system_commission_percent] = true
        params.each do |key, value|
          settings.destroy key rescue nil
        end
      end
    end
    redirect_to settings_admin_merchant_path(@merchant)
  end

  def update_product
    products = Array.new
    merchant_params[:merchant_attributes][:skills].each{ |product|
      if product[:is_checked]=="1"
        product.delete :is_checked
        products << @merchant.merchant.products.new(product) unless product[:skill_id].empty?
      end
    }
    @merchant_params=merchant_params
    @merchant_params[:merchant_attributes][:products]=[]
    @merchant.merchant.products.push(products)
    redirect_to product_admin_merchant_path(@merchant)
  end

  private

    def find_merchant
      @merchant = Store.find(params[:id])
    end

    def setting_params
      params.require(:store_scoped_settings).permit(:use_system_commission_percent,
        :commission_percent, :mobile_commission_percent, :client_commission_percent,
        :mechanic_commission_percent)
    end

    def merchant_params
      params.require(:merchant).permit(
        merchant_attributes: [skills: [[:is_checked, :price, :skill_id]]  ])
    end



end
