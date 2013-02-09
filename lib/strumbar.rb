require 'strumbar/version'
require 'strumbar/configuration'
require 'strumbar/client'
require 'strumbar/instrumentation'

require 'active_support'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/module/delegation'

module Strumbar
  class << self
    def configure
      @configuration = Configuration.new
      yield @configuration
      Instrumentation.load
    end

    def client
      @client ||= Client.new host, port
    end

    def configuration
      @configuration ||= Configuration.new
    end

    delegate :host, :port, :instruments, :application, :default_rate, to: :configuration

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
