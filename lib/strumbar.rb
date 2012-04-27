require 'strumbar/version'
require 'strumbar/configuration'
require 'strumbar/client'

require 'active_support'

module Strumbar
  class << self
    attr_reader :configuration

    def configure
      @configuration = Configuration.new
      yield @configuration
      load_default_subscriptions
    end

    def client
      host = configuration ? configuration.host : 'localhost'
      port = configuration ? configuration.port : 8125
      @client ||= Client.new host, port
    end

    def subscribe identifier
      ActiveSupport::Notifications.subscribe identifier do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        yield client, event
      end
    end

    def load_default_subscriptions
      subscribe_to_controller
      subscribe_to_database
    end

    def subscribe_to_controller
      subscribe /process_action.action_controller/ do |client, event|
        client.timing     "total_time.#{event.name}", event.duration
        client.timing     "view_time.#{event.name}",  event.payload[:view_runtime]
        client.timing     "db_time.#{event.name}",    event.payload[:db_runtime]
      end
    end

    def subscribe_to_database
      subscribe /sql.active_record/ do |client, event|
        client.timing 'query_log', event.duration
      end
    end

    def strum event, payload, &block
      ActiveSupport::Notifications.instrument event, payload, &block
    end
  end
end
