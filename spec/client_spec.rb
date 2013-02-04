require 'spec_helper'

module Strumbar
  describe Client do
    let(:client) {
      Client.new('test', 1234)
    }

    STATSD_CODES = {
      'increment' => :c,
      'decrement' => :c,
      'count'     => :c,
      'timing'    => :ms,
      'gauge'     => :g,
      'set'       => :s
    }

    STATSD_CODES.each do |method, code|
      describe "##{method}" do
        it "proxies to #send_stats with a namespaced key and the right code" do
          value = case method
          when 'increment'
            1
          when 'decrement'
            -1
          else
            100
          end

          client.should_receive(:send_stats).with("#{Strumbar.application}.foo", value, code, Strumbar.default_rate)

          if %w(increment decrement).include? method
            client.send method, 'foo'
          else
            client.send method, 'foo', value
          end
        end
      end
    end

  end
end