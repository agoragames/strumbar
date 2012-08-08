require 'spec_helper'

describe Strumbar::Instrumentation do
  describe '#load' do
    def undefine klass
      Object.send :remove_const, klass
    end

    context 'with all instrumentations enabled' do
      before do
        Strumbar.configure do |c|
          c.action_controller = true
          c.active_record = true
          c.redis = true
        end
      end

      it 'loads the ActionController subscription if ActionController is defined' do

        ActionController = true

        Strumbar::Instrumentation::ActionController.should_receive :load
        Strumbar::Instrumentation.load

        undefine :ActionController
      end

      it 'does not load ActionController subscription if not defined' do
        Strumbar::Instrumentation::ActionController.should_not_receive :load
        Strumbar::Instrumentation.load
      end

      it 'loads the ActiveRecord subscription if ActiveRecord is loaded' do
        ActiveRecord = true

        Strumbar::Instrumentation::ActiveRecord.should_receive :load
        Strumbar::Instrumentation.load

        undefine :ActiveRecord
      end

      it 'does not load ActiveRecord subscription if not defined' do
        Strumbar::Instrumentation::ActiveRecord.should_not_receive :load
        Strumbar::Instrumentation.load
      end

      it 'loads the Redis subscription if Redis is defined' do
        class Redis
          class Client
            def process ; end
          end
        end

        Strumbar::Instrumentation::Redis.should_receive :load
        Strumbar::Instrumentation.load

        undefine :Redis
      end

      it 'does not load Redis subscription if not defined' do
        Strumbar::Instrumentation::Redis.should_not_receive :load
        Strumbar::Instrumentation.load
      end

    end

    context 'with all instrumentations disabled' do
      before do
        Strumbar.configure do |c|
          c.action_controller = false
          c.active_record = false
          c.redis = false
        end
      end

      it 'does not load the ActionController subscription even if ActionController is defined' do

        ActionController = true

        Strumbar::Instrumentation::ActionController.should_not_receive :load
        Strumbar::Instrumentation.load

        undefine :ActionController
      end

      it 'does not load the ActiveRecord subscription even if ActiveRecord is loaded' do
        ActiveRecord = true

        Strumbar::Instrumentation::ActiveRecord.should_not_receive :load
        Strumbar::Instrumentation.load

        undefine :ActiveRecord
      end

      it 'does not load the Redis subscription even if Redis is defined' do
        class Redis
          class Client
            def process ; end
          end
        end

        Strumbar::Instrumentation::Redis.should_not_receive :load
        Strumbar::Instrumentation.load

        undefine :Redis
      end

    end

  end
end
