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

    def use instruments, options = {}
      if instruments.respond_to? :each
        instruments.each do |instrument|
          add instrument, options
        end
      else
        add instruments, options
      end
    end

    def delete instrument
      @instruments.delete_if { |i| i[0] == instrument }
    end

    private

    def add instrument, options
      if instrument.respond_to? :load
        @instruments << [instrument, options]
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
