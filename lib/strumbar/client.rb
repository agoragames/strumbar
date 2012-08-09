require 'statsd'

module Strumbar
  class Client < ::Statsd::Client
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
  end
end
