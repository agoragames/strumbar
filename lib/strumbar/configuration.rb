module Strumbar
  class Configuration
    attr_accessor :port,
                  :host,
                  :application,
                  :default_rate,
                  :custom_load

    def instrumentation(&block)
      @custom_load = block
    end
  end
end
