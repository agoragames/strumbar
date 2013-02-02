module Strumbar
  module Instrumentation
    module ActionController
      def self.load(options={})
        options[:rate]    ||= Strumbar.default_rate
        using_mongoid = options.fetch(:mongoid, false)

        Strumbar.subscribe /process_action.action_controller/ do |client, event|
          key = "#{event.payload[:controller]}.#{event.payload[:action]}"
          db_runtime = if using_mongoid
            event.payload[:mongo_runtime]
          else
            event.payload[:db_runtime]
          end

          client.timing     "#{key}.total_time", event.duration, options[:rate]
          client.timing     "#{key}.view_time",  event.payload[:view_runtime], options[:rate]
          client.timing     "#{key}.db_time",    db_runtime, options[:rate]

          client.increment  "#{key}.status.#{event.payload[:status]}", options[:rate]
        end
      end
    end
  end
end
