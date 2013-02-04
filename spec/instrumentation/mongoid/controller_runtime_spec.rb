require 'spec_helper'

class AbstractHarness
  def process_action action, *args
    "Processed."
  end

  def append_info_to_payload payload
    payload
  end

  def self.log_process_action payload
    []
  end
end

module Strumbar
  module Instrumentation
    module Mongoid
      describe ControllerRuntime do
        let(:test_harness) {
          Class.new(AbstractHarness) do
            include ControllerRuntime

            public :time_tracker, :process_action, :append_info_to_payload
          end
        }

        describe "#time_tracker" do
          it "is a convenient way access the RuntimeTracker class" do
            test_harness.new.time_tracker.should == RuntimeTracker
          end
        end

        describe "#process_action" do
          it "resets the tracker" do
            test_harness.new.time_tracker.runtime = 1000

            test_harness.new.process_action :my_action
            test_harness.new.time_tracker.runtime.should == 0
          end
        end

        describe ".log_process_action" do
          it "adds the Mongo runtime to the list of messages to be logged" do
            messages = test_harness.log_process_action({ mongo_runtime: 1000 })
            messages.should == ["Mongo: 1000.0ms"]
          end
        end

      end
    end
  end
end