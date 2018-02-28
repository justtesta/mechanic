class Merchants::NumbersController < Merchants::ApplicationController
  before_action :find_number , only: [ :edit, :update, :destroy ]


  def index
    @order = Order.find(params[:order_id])
    @numbers = @order.numbers
  end

  def new
    @order = Order.find(params[:order_id])
    @number =@order.numbers.new
  end

  def create
    @order = Order.find(params[:order_id])
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
      render :eidt
    end
  end


  def destroy
    @number.destroy
    redirect_to merchants_order_numbers_path
  end

  private

    def find_number
      @order = Order.find(params[:order_id])
      @number =@order.numbers.find(params[:id])
    end

    def number_params
      params.require(:number).permit(:pwd_number_default)
    end
end
