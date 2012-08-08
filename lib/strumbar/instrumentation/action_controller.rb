module Strumbar
  module Instrumentation
    module ActionController
      def self.load
        Strumbar.subscribe /process_action.action_controller/ do |client, event|
          key = "#{event.payload[:controller]}.#{event.payload[:action]}"

          client.timing     "#{key}.total_time", event.duration, Strumbar.action_controller_rate
          client.timing     "#{key}.view_time",  event.payload[:view_runtime], Strumbar.action_controller_rate
          client.timing     "#{key}.db_time",    event.payload[:db_runtime], Strumbar.action_controller_rate

          client.increment  "#{key}.status.#{event.payload[:status]}", Strumbar.action_controller_rate
        end
      end
    end
  end
end
