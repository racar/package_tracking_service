class TrackingsController < ApplicationController
  def update
    package = FedexService.find_by(tracking_number: tracking_id)
    if package
      TrackFedexJob.perform_now(package)
    else
      render_unprocessable
    end
  end

  private

  def tracking_id
    params[:tracking_id]
  end

  def render_unprocessable
    render json: "Tracking number #{ tracking_id } not found.", status: :unprocessable_entity
  end
end
