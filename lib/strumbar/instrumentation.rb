module Strumbar
  module Instrumentation
    autoload :Redis, 'strumbar/instrumentation/redis'
    autoload :ActionController, 'strumbar/instrumentation/action_controller'
    autoload :ActiveRecord, 'strumbar/instrumentation/active_record'

    def self.load
      if Strumbar.action_controller && defined?(::ActionController)
        Strumbar::Instrumentation::ActionController.load
      end

      if Strumbar.active_record && defined?(::ActiveRecord)
        Strumbar::Instrumentation::ActiveRecord.load
      end

      if Strumbar.redis && defined?(::Redis)
        Strumbar::Instrumentation::Redis.load
      end
    end
  end
end
