module Strumbar
  module Instrumentation
    autoload :Redis, 'strumbar/instrumentation/redis'
    autoload :ActionController, 'strumbar/instrumentation/action_controller'
    autoload :ActiveRecord, 'strumbar/instrumentation/active_record'

    def self.load
      Strumbar::Instrumentation::ActionController.load if defined? ::ActionController
      Strumbar::Instrumentation::ActiveRecord.load if defined? ::ActiveRecord
      Strumbar::Instrumentation::Redis.load if defined? ::Redis
    end
  end
end