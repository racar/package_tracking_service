class TrackingsController < ApplicationController
  def update
    package = FedexService.find_by(tracking_number: tracking_id)
    if package
      binding.pry
      begin
        TrackFedexJob.perform_now(package)
      rescue StandardError => e
        render_unprocessable("Carrier searching error: #{e.message}")
      end
    else
      render_unprocessable("Tracking number #{tracking_id} not found.")
    end
  end

  private

  def tracking_id
    params[:tracking_id]
  end

  def render_unprocessable(msg)
    render json: msg, status: :unprocessable_entity
  end
end
