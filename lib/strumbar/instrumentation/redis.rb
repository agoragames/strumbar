module Strumbar
  module Instrumentation
    module Redis
      def self.load
        Strumbar.subscribe 'query.redis' do |client, event|
          client.increment 'query.redis'
        end

        unless ::Redis::Client.instance_methods.include? :process_with_instrumentation
          ::Redis::Client.class_eval do
            def process_with_instrumentation commands
              Strumbar.strum 'query.redis', commands: commands do
                process_without_instrumentation commands
              end
            end

            alias_method :process_without_instrumentation, :process
            alias_method :process, :process_with_instrumentation
          end
        end
      end
    end
  end
end
