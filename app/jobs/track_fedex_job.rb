class TrackFedexJob < TrackJob
  def perform(*args)
    super(*args)

    update_status unless same_status?
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

  def update_status
    package_to_track.status = status_normalization
    package_to_track.save
  end

  def status_normalization
    tracking_info.details[:status].upcase
  end
end
