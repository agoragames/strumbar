require 'spec_helper'

class Redis
  class Client
    def process commands
      yield if block_given? 
    end

    def validate
      true
    end
  end
end

describe Strumbar::Instrumentation::Redis do
  before do
    Strumbar::Instrumentation::Redis.load
  end

  after do
    ActiveSupport::Notifications.unsubscribe('query.redis')
  end

  it 'adds a wrapper around Redis#process to instrument redis calls' do
    Strumbar.should_receive(:strum).with('query.redis', { commands: ['set'] })
    Redis::Client.new.process ['set']
  end

  it 'subscribes to query.redis notifications' do
    Strumbar.client.should_receive(:increment).with('query.redis')
    Strumbar.strum 'query.redis', {}
  end

  it 'passes blocks in #process accordingly' do
    client = Redis::Client.new
    client.process 'foo'
  end
end
