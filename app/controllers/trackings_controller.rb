class TrackingsController < ApplicationController
  def update
    if package
      begin
        TrackFedexJob.perform_now(package)
        render_ok
      rescue StandardError => e
        render_unprocessable("Carrier searching error: #{e.message}")
      end
    else
      render_unprocessable("Tracking number #{tracking_id} not found.")
    end
  end

  private

  def package
    @package ||= FedexService.find_by(tracking_number: tracking_id)
  end

  def tracking_id
    params[:tracking_id]
  end

  def render_unprocessable(msg)
    render json: msg, status: :unprocessable_entity
  end

  def render_ok
    render json: 'OK', status: :ok
  end
end
