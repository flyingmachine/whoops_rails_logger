require 'spec_helper'

describe WhoopsRailsLogger do
  describe ".configure" do
    it "should set the logger to the rails logger" do
      WhoopsLogger.config.logger.should == Rails.logger
    end

    it "should set the WhoopsLogger sender config options" do
      WhoopsLogger.config.host.should == "whoops.com"
    end
  end
end