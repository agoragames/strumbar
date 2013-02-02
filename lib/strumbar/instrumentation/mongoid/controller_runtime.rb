module Strumbar
  module Instrumentation
    module Mongoid
      # Seems a little out of scope for Strumbar, but honestly you're probably going to want
      # this if you want to get anything out of instrumenting Mongoid.
      module ControllerRuntime
        extend ActiveSupport::Concern

        protected

        attr_internal :mongo_runtime

        def time_tracker
          Strumbar::Instrumentation::Mongoid::RuntimeTracker
        end

        def process_action(action, *args)
          time_tracker.reset
          super
        end

        def cleanup_view_runtime
          mongo_rt_before_render = time_tracker.reset
          runtime = super
          mongo_rt_after_render = time_tracker.reset
          self.mongo_runtime = mongo_rt_before_render + mongo_rt_after_render

          runtime - mongo_rt_after_render
        end

        def append_info_to_payload(payload)
          super
          payload[:mongo_runtime] = mongo_runtime
        end

        module ClassMethods
          def log_process_action(payload)
            messages, mongo_runtime = super, payload[:mongo_runtime]
            messages << ("Mongo: %.1fms" % mongo_runtime.to_f) if mongo_runtime
            messages
          end
        end
      end
    end
  end
end