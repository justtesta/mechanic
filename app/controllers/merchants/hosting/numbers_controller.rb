class Merchants::Hosting::NumbersController < Merchants::ApplicationController
before_action :redirect_user_dispatcher, only: [ :index ]
  def index
    @state = if %w(unchecked_numbers checked_numbers).include? params[:state]
        params[:state].to_sym
      else
        :unchecked_numbers
      end
    @numbers = Number.send(@state)
  end
  def checked?
    status && ["1", 1, true].include?(status)
  end
  
end