require 'spec_helper'

describe Strumbar do
  it 'loads' do
    true
  end

  after do
    Strumbar.instance_variable_set(:@configuration, nil)
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

    it 'loads relevant Instrumentation' do
      Strumbar::Instrumentation.should_receive(:load)
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

  describe 'after #configure' do
    context 'with default values' do
      before { Strumbar.configure { } }
      subject { Strumbar }

      its(:default_rate) { should == 1 }

      its(:action_controller) { should be_false }
      its(:action_controller_rate) { should eql 1 }

      its(:active_record) { should be_false }
      its(:active_record_rate) { should eql 1 }

      its(:redis) { should be_false }
      its(:redis_rate) { should eql 1 }
    end

    context 'with user values' do
      before do
        Strumbar.configure do |c|
          c.default_rate = 0.5
          c.action_controller = true
          c.action_controller_rate = 0.1
          c.active_record = true
          c.active_record_rate = 0.2
          c.redis = true
          c.redis_rate = 0.3
        end
      end
      subject { Strumbar }

      its(:default_rate) { should == 0.5 }

      its(:action_controller) { should be_true }
      its(:action_controller_rate) { should eql 0.1 }

      its(:active_record) { should be_true }
      its(:active_record_rate) { should eql 0.2 }

      its(:redis) { should be_true }
      its(:redis_rate) { should eql 0.3 }
    end
  end

  describe "#application" do
    it "returns the configured value" do
      Strumbar.configure { |c| c.application = "foobar" }
      Strumbar.application.should == "foobar"
    end
    it "defaults to something comically bad so you'll change it" do
      Strumbar.application.should == "statsd_appname"
    end
  end

  describe "#host" do
    it "returns the configured value" do
      Strumbar.configure { |c| c.host = "statsd.app" }
      Strumbar.host.should == "statsd.app"
    end
    it "defaults to localhost" do
      Strumbar.host.should == "localhost"
    end
  end

  describe "#port" do
    it "returns the configured port" do
      Strumbar.configure { |c| c.port = 9999 }
      Strumbar.port.should == 9999
    end
    it "defaults to 8125" do
      Strumbar.port.should == 8125
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
