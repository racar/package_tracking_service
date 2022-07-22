class TrackFedexJob < TrackJob
  retry_on Timeout::Error, wait: 30.seconds, attempts: 3

  ON_TRANSIT_STATUSES = ['AT PICKUP', 'ARRIVED AT FEDEX LOCATION','SHIPMENT INFORMATION SENT TO FEDEX'].freeze

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
    return 'ON_TRANSIT' if ON_TRANSIT_STATUSES.include? tracking_info.status.upcase

    tracking_info.status.upcase
  end

  def publish_event
    UpdateStatusEvent.new.publish(payload.to_json)
  end

  def payload
    {
    track_id: tracking_info.details[:tracking_number_unique_identifier],
    status: status_demo_helper, #status_normalization,
    description: tracking_info.details[:status_description],
    status_code: tracking_info.details[:status_code],
    carrier_code: tracking_info.details[:carrier_code],
    packaging_type: tracking_info.details[:packaging_type],
    dimensions: tracking_info.details[:package_dimensions]
    }
  end

  def status_demo_helper
    ['DISTRIBUTION_CENTER', 'TRANSPORT_CENTER', 'ON_TRANSIT', 'AIRLINE_OUTPUT', 'ON_DISTRIBUTION'].sample
  end
end
