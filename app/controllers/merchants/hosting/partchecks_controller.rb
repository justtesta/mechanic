class Merchants::Hosting::PartchecksController < Merchants::ApplicationController
  before_action :redirect_user_dispatcher
  def index
    
    @partchecks = @order.partchecks
  end

  
end