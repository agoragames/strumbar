module Strumbar
  module Instrumentation
    module ActiveRecord
      def self.load(options={})
        options[:rate] ||= Strumbar.default_rate

        Strumbar.subscribe /sql.active_record/ do |client, event|
          client.timing 'query_log', event.duration, options[:rate]
        end
      end
    end
  end
end
