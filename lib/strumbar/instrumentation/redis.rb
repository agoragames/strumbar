module Strumbar
  module Instrumentation
    module Redis
      def self.load(options={})
        options[:rate] ||= Strumbar.default_rate

        Strumbar.subscribe 'query.redis' do |client, event|
          client.increment 'query.redis', options[:rate]
          client.increment('failure.redis', options[:rate]) if event.payload[:failure]

          command = case event.payload[:command]
            when NilClass then nil
            when String then event.payload[:command]
            else event.payload[:command].join('_')
          end

          command.gsub!(/:/, '_') unless command.nil?

          client.timing "#{command}.redis", event.duration, options[:rate]
        end

        unless ::Redis::Client.instance_methods.include? :call_with_instrumentation
          ::Redis::Client.class_eval do
            def call_with_instrumentation command, &block
              Strumbar.strum 'query.redis', command: command do |payload|
                call_without_instrumentation command, &block
                begin
                  reply = call_without_instrumentation command, &block 
                  payload[:failure] = false
                rescue CommandError
                  payload[:failure] = true
                  raise
                end

                reply
              end
            end

            alias_method :call_without_instrumentation, :call
            alias_method :call, :call_with_instrumentation
          end
        end
      end
    end
  end
end
