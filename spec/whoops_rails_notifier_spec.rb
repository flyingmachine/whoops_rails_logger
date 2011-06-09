require 'spec_helper'

describe WhoopsRailsNotifier do
  describe ".configure" do
    it "should set the logger to the rails 3 logger" do
      WhoopsNotifier.config.logger.should == Rails.logger
    end
  end
end