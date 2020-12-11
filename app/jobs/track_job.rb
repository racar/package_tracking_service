class TrackJob < ApplicationJob
  attr_reader :package_to_track
  queue_as :default

  def perform(*args)
    @package_to_track, arg2 = *args
  end

  private

  def tracking_info
    raise NotImplementedError
  end

  def request
    raise NotImplementedError
  end
end
