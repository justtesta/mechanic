class Merchants::NumbersController < Merchants::ApplicationController
  before_action :find_note

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
      redirect_to merchants_numbers_path
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:order_id])
    @number =@order.numbers.find(params[:id])
  end

  def update
    if @note.update_attributes(note_params)
      flash[:notice] = "成功更新记事本！"
      redirect_to merchants_note_path
    else
      render :show
    end
  end

  private

    def find_note
      @note = current_store.notes.first_or_create
    end

    def number_params
      params.require(:number).permit(:pwd_number_default)
    end
end
