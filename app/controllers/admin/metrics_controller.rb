class Admin::MetricsController < Admin::ApplicationController


  def index
    @metrics = if params[:mechanic_id]
        @mechanic = Mechanic.where(user_id: params[:mechanic_id]).first!
        Metrics.where(user_id: params[:mechanic_id])
      else
        Metrics.all
      end
  end

  private

end
