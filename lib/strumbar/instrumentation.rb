module Strumbar
  module Instrumentation
    autoload :ActionController, 'strumbar/instrumentation/action_controller'
    autoload :ActiveRecord, 'strumbar/instrumentation/active_record'
    autoload :Mongoid, 'strumbar/instrumentation/mongoid'
    autoload :Redis, 'strumbar/instrumentation/redis'

    def self.load
      Strumbar.instruments.each do |instrument_info|
        instrument  = instrument_info[0]
        options     = instrument_info[1]

        options[:rate] ||= Strumbar.default_rate

        instrument.load options
      end
    end
  end
end
