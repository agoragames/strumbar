require 'spec_helper'

describe Strumbar do
  it 'loads' do
    true
  end

  describe '#client' do
    after do
      Strumbar.instance_variable_set(:@client, nil)
    end

    it { Strumbar.client.should be_a_kind_of Strumbar::Client }

    it 'defaults host to localhost' do
      Strumbar.client.host.should == 'localhost'
    end

    it 'defaults port to 8125' do
      Strumbar.client.port.should == 8125
    end

    it 'uses the Strumbar configuration if configuration is present' do
      Strumbar.configure do |config|
        config.port = 12345
        config.host = '127.0.0.1'
      end

      Strumbar.client.port.should == 12345
      Strumbar.client.host.should == '127.0.0.1'
    end
  end

  describe '#configure' do
    it 'yields a Configuration object' do
      Strumbar.configure do |config|
        config.should be_a_kind_of Strumbar::Configuration
      end
    end

    it 'calls load_default_subscriptions' do
      Strumbar.should_receive(:load_default_subscriptions)
      Strumbar.configure { |c| }
    end

    it 'assigns the configuration object to Strumbar' do
      @config_object = nil
      Strumbar.configure do |config|
        config.port = 12345
        config.host = '127.0.0.1'
        @config_object = config
      end

      Strumbar.configuration.should == @config_object
    end
  end

  describe '#subscribe' do
    it 'should wrap ActiveSupport::Notifications' do
      ActiveSupport::Notifications.should_receive(:subscribe).with('foo')
      Strumbar.subscribe 'foo'
    end

    it 'should yield an event and client on instrument call' do
      Strumbar.subscribe 'foo' do |client, event|
        event.should be_a_kind_of ActiveSupport::Notifications::Event
        client.should be_a_kind_of Strumbar::Client
      end
      ActiveSupport::Notifications.instrument 'foo'
    end
  end

  describe "#strum" do
    it "is syntactic sugar for ActiveSupport::Notifications.instrument" do
      ActiveSupport::Notifications.should_receive(:instrument).with("event_name", { :payload => :yeah })
      Strumbar.strum("event_name", { payload: :yeah })
    end
    it "handles the block correctly and all that jazz" do
      foo = nil
      ActiveSupport::Notifications.should_receive(:instrument).and_yield
      Strumbar.strum("mah.event", {}) do
        foo = 7
      end
      foo.should == 7
    end
  end
end
