class Admin::MetricsController < Admin::ApplicationController


  def index
    @metrics = if params[:mechanic_id]
        @mechanic = Mechanic.where(user_id: params[:mechanic_id]).first!
        Metric.where(user_id: params[:mechanic_id])
      else
        Metric.all
      end
  end

  private

end
