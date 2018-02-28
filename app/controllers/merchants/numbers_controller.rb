class Merchants::NumbersController < Merchants::ApplicationController
  before_action :find_order
  before_action :find_number , only: [ :edit, :update, :destroy ]
  before_action :redirect_mechanic


  def index
    @numbers = @order.numbers
  end

  def new
    @number =@order.numbers.new
  end

  def create
    @number = @order.numbers.new(number_params)
    if @number.save
      redirect_to merchants_order_numbers_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @number.update_attributes(number_params)
      flash[:notice] = "成功更新核销码！"
      redirect_to merchants_order_numbers_path
    else
      render :show
    end
  end


  def destroy
    @number.destroy
    redirect_to merchants_order_numbers_path
  end

  private

    def find_order
        @order = order_klass.find(params[:order_id])
    end

    def find_number
      @number =@order.numbers.find(params[:id])
    end

    def order_klass
      Order.where(user_id: current_store, merchant_id: current_merchant)
    end

    def number_params
      params.require(:number).permit(:pwd_number_default)
    end
end
