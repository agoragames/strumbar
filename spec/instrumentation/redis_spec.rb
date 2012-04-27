require 'spec_helper'

describe Strumbar::Instrumentation::Redis do
  before do
    class Redis
      class Client
        def call command, &block
          
        end

        def validate
          true
        end
      end
    end
    Strumbar::Instrumentation::Redis.load
  end

  after do
    ActiveSupport::Notifications.unsubscribe('query.redis')
    Object.send :remove_const, :Redis
  end

  it 'adds a wrapper around Redis#call to instrument redis calls' do
    Strumbar.should_receive(:strum).with('query.redis', { command: 'SET' })
    Redis::Client.new.call 'SET'
  end

  it 'subscribes to query.redis notifications' do
    Strumbar.client.should_receive(:increment).with('query.redis')
    Strumbar.strum 'query.redis', {}
  end

  it 'passes blocks in #call accordingly' do
    client = Redis::Client.new
    client.call 'foo'
  end
end
