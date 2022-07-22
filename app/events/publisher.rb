# frozen_string_literal: true

require 'dotenv/load'
# Publish to rabbitMQ
class Publisher
  URL = ENV['CLOUDAMQP_URL']

  def publish(msg)
    raise NotImplementedError
  end

  def connection
    @connection ||= Bunny.new URL
  end

  def channel
    @channel ||= connection.create_channel
  end

  def queue
    @queue ||= channel.queue(queue_name, :durable => true)
  end

  def exchange
    channel.exchange('')
  end

  def queue_name
    raise NotImplementedError
  end
end
