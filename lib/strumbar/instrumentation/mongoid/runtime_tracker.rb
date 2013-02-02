module Strumbar
  module Instrumentation
    module Mongoid
      # This is basically how ActiveRecord instruments this, although they use a LogSubscriber,
      # for no adequately explained reason. I'm not sure if we should include the controller mixin
      # in Strumbar or not? Seems simultaneously in and out of scope.
      class RuntimeTracker
        RUNTIME_KEY = 'Mongoid::RuntimeTracker#runtime'
        COUNT_KEY = 'Mongoid::RuntimeTracker#count'

        def self.runtime= value
          Thread.current[RUNTIME_KEY] = value
        end

        def self.runtime
          Thread.current[RUNTIME_KEY] ||= 0
        end

        def self.count= value
          Thread.current[COUNT_KEY] = value
        end

        def self.count
          Thread.current[COUNT_KEY] ||= 0
        end

        def self.reset
          time, self.runtime, self.count = runtime, 0, 0
          time
        end
      end
    end
  end
end