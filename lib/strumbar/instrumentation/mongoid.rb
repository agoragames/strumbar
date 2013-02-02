require 'strumbar/instrumentation/mongoid/runtime_tracker'
require 'strumbar/instrumentation/mongoid/controller_runtime'

module Strumbar
  module Instrumentation
    module Mongoid
      CALLS_TO_BE_INSTRUMENTED = [ :read, :write ]

      def self.load(options={})
        options[:rate] ||= Strumbar.default_rate

        Strumbar.subscribe 'mongo.mongoid' do |client, event|
          RuntimeTracker.runtime += event.duration
          RuntimeTracker.count   += 1
        end

        if defined?(::ActionController)
          ActiveSupport.on_load(:action_controller) do
            include ControllerRuntime
          end
        end

        unless ::Moped::Connection.instance_methods.include? :call_with_instrumentation
          ::Moped::Connection.module_eval do
            CALLS_TO_BE_INSTRUMENTED.each do |method|
              class_eval <<-CODE, __FILE__, __LINE__ + 1
                def #{method}_with_instrumentation(*args, &block)
                  Strumbar.strum 'mongo.mongoid', name: "#{method}" do
                    #{method}_without_instrumentation(*args, &block)
                  end
                end
              CODE

              alias_method_chain method, :instrumentation
            end
          end
        end
      end # of self.load

    end
  end
end