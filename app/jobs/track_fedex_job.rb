class TrackFedexJob < TrackJob
  def perform(*args)
    super(*args)

    return if same_status?

    update_status
    publish_event
  end

  private

  def tracking_info
    @tracking_info ||= request.track(tracking_number: package_to_track.tracking_number).first
  end

  def request
    Fedex::Shipment.new(key: 'O21wEWKhdDn2SYyb',
                        password: 'db0SYxXWWh0bgRSN7Ikg9Vunz',
                        account_number: '510087780',
                        meter: '119009727',
                        mode: 'test')
  end

  def same_status?
    package_to_track.status == tracking_info.status
  end

  def status_normalization
    tracking_info.status.upcase
  end

  def publish_event
    UpdateStatusEvent.new.publish(payload.to_json)
  end

  def payload
    {
      track_id: tracking_info.details[:tracking_number_unique_identifier],
      status: status_normalization,
      description: tracking_info.details[:status_description],
      status_code: tracking_info.details[:status_code],
      carrier_code: tracking_info.details[:carrier_code],
      packaging_type: tracking_info.details[:packaging_type],
      dimensions: tracking_info.details[:package_dimensions]
    }
  end
end
