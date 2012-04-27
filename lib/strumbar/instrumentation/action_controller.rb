module Strumbar
  module Instrumentation
    module ActionController
      def self.load
        Strumbar.subscribe /process_action.action_controller/ do |client, event|
          key = "#{event.payload[:controller]}.#{event.payload[:action]}"

          client.timing     "#{key}.total_time", event.duration
          client.timing     "#{key}.view_time",  event.payload[:view_runtime]
          client.timing     "#{key}.db_time",    event.payload[:db_runtime]

          client.increment  "#{key}.status.#{event.payload[:status]}"
        end
      end
    end
  end
end
