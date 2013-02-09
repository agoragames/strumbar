require 'spec_helper'

module Strumbar
  describe Configuration do
    let(:config) { Configuration.new }

    context "default configuration values" do
      it "defaults #host to 'localhost'" do
        config.host.should == 'localhost'
      end

      it "defaults #port to 8125" do
        config.port.should == 8125
      end

      it "defaults #application to 'statsd_appname'" do
        config.application.should == 'statsd_appname'
      end

      it "defaults #default_rate to 1" do
        config.default_rate.should == 1
      end
    end

  end
end