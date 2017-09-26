class Merchants::Hosting::NumbersController < Admin::ApplicationController

  def index
    @state = if %w(unchecked_numbers checked_numbers).include? params[:state]
        params[:state].to_sym
      else
        :unchecked_numbers
      end
    @numbers = Number.send(@state)
  end
  
end