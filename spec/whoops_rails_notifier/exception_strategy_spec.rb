require 'spec_helper'

describe WhoopsRailsNotifier::ExceptionStrategy do
  it "uses the rails application name for service by default" do
    WhoopsNotifier.strategies[:rails_exception].service.should == "dummy"
  end
  
  it "uses the rails environment for environment by default" do
    WhoopsNotifier.strategies[:rails_exception].environment.should == "test"
  end
end
