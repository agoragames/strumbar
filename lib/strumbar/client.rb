require 'statsd'

module Strumbar
  class Client < ::Statsd::Client
    def initialize host, port
      @host = host
      @port = port
    end

    def timing stat, time, sample_rate = 1
      super "#{Strumbar.configuration.application}.#{stat}", time, sample_rate
    end

    def increment stat, sample_rate = 1
      super "#{Strumbar.configuration.application}.#{stat}", sample_rate
    end

    def decrement stat, sample_rate = 1
      super "##{Strumbar.configuration.application}.#{stat}", sample_rate
    end
  end
end
