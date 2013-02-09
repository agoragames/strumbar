module Strumbar
  class InstrumentList
    include Enumerable

    def initialize
      @instruments = []
    end

    def each &block
      @instruments.each &block
    end

    def empty?
      @instruments.empty?
    end

    def use instruments
      if instruments.respond_to? :each
        instruments.each do |instrument|
          add instrument
        end
      else
        add instruments
      end
    end

    def delete instrument
      @instruments.delete instrument
    end

    private

    def add instrument
      if instrument.respond_to? :load
        @instruments << instrument
      else
        raise 'Instrument does not respond to load'
      end
    end
  end

  class Configuration
    attr_accessor :port,
                  :host,
                  :application,
                  :default_rate,
                  :instruments

    def initialize
      @instruments = InstrumentList.new
    end

    def host
      @host || 'localhost'
    end

    def port
      @port || 8125
    end

    def application
      @application || 'statsd_appname'
    end

    def default_rate
      @default_rate || 1
    end
  end
end
