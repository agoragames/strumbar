require 'spec_helper'

module Strumbar
  module Instrumentation
    module Mongoid
      describe RuntimeTracker do
        %w(runtime count).each do |attribute|
          describe ".#{attribute}" do
            it "is a class attribute" do
              RuntimeTracker.send("#{attribute}=", 100)
              RuntimeTracker.send(attribute).should == 100
            end
          end
        end
      end

      describe ".reset" do
        it "returns the current runtime" do
          RuntimeTracker.runtime = 1500

          RuntimeTracker.reset.should == 1500
        end

        it "resets the count and runtime attributes" do
          RuntimeTracker.runtime = 1000
          RuntimeTracker.count = 2

          RuntimeTracker.reset
          RuntimeTracker.runtime.should == 0
          RuntimeTracker.count.should == 0
        end
      end
    end
  end
end
