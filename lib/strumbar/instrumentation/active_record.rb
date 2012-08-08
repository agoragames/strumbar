module Strumbar
  module Instrumentation
    module ActiveRecord
      def self.load
        Strumbar.subscribe /sql.active_record/ do |client, event|
          client.timing 'query_log', event.duration, Strumbar.active_record_rate
        end
      end
    end
  end
end
