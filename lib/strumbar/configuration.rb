module Strumbar
  class Configuration
    attr_accessor :port,
                  :host,
                  :application,
                  :default_rate,
                  :action_controller,
                  :action_controller_rate,
                  :active_record,
                  :active_record_rate,
                  :redis,
                  :redis_rate
  end
end
