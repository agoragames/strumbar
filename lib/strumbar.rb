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

    def instruments
      configuration.instruments
    end

    def application
      configuration.try(:application) || 'statsd_appname'
    end

    def default_rate
      configuration.try(:default_rate) || 1
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
