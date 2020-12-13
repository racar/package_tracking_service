class UpdateStatusEvent < Publisher
  def publish(msg)
    connection.start
    exchange.publish(msg, key: queue.name)
  ensure
    connection.close
  end

  private

  def queue_name
    'update_tracking_status'
  end
end
