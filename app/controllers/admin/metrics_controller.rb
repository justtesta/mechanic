class Admin::MetricsController < Admin::ApplicationController


  def index
    @metrics = if params[:mechanic_id]
        @mechanic = Mechanic.where(user_id: params[:mechanic_id]).first!
        @mechanic.metrics
      else
        Metrics.all
      end
  end

  private

end
