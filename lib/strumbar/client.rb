require 'statsd'

module Strumbar
  class Client < ::Statsd
    def initialize host, port
      @host = host
      @port = port
    end

    def timing stat, time, sample_rate = Strumbar.default_rate
      super "#{Strumbar.application}.#{stat}", time, sample_rate
    end

    def increment stat, sample_rate = Strumbar.default_rate
      super "#{Strumbar.application}.#{stat}", sample_rate
    end

    def decrement stat, sample_rate = Strumbar.default_rate
      super "##{Strumbar.application}.#{stat}", sample_rate
    end

    def gauge stat, value
      super "##{Strumbar.application}.#{stat}", value
    end
  end
end
