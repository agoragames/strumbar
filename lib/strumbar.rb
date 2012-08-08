require 'strumbar/version'
require 'strumbar/configuration'
require 'strumbar/client'
require 'strumbar/instrumentation'

require 'active_support'
require 'active_support/core_ext/object/try'

module Strumbar
  class << self
    attr_reader :configuration

    def configure
      @configuration = Configuration.new
      yield @configuration
      Instrumentation.load
    end

    def client
      @client ||= Client.new host, port
    end

    def host
      configuration.try(:host) || 'localhost'
    end

    def port
      configuration.try(:port) || 8125
    end

    def application
      configuration.try(:application) || 'statsd_appname'
    end

    def default_rate
      configuration.try(:default_rate) || 1
    end

    def action_controller
      configuration.try(:action_controller) || false
    end

    def action_controller_rate
      configuration.try(:action_controller_rate) || 1
    end

    def active_record
      configuration.try(:active_record) || false
    end

    def active_record_rate
      configuration.try(:active_record_rate) || 1
    end

    def redis
      configuration.try(:redis) || false
    end

    def redis_rate
      configuration.try(:redis_rate) || 1
    end

    def subscribe identifier
      ActiveSupport::Notifications.subscribe identifier do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        yield client, event
      end
    end

    def strum event, payload, &block
      ActiveSupport::Notifications.instrument event, payload, &block
    end
  end
end
