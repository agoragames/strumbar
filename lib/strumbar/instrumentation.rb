module Strumbar
  module Instrumentation
    autoload :ActionController, 'strumbar/instrumentation/action_controller'
    autoload :ActiveRecord, 'strumbar/instrumentation/active_record'
    autoload :Mongoid, 'strumbar/instrumentation/mongoid'
    autoload :Redis, 'strumbar/instrumentation/redis'

    def self.load
      Strumbar.instruments.each do |instrument|
        instrument.load
      end
    end
  end
end
