require 'spec_helper'

describe WhoopsRailsLogger::ExceptionStrategy do
  it "uses the rails application name for service by default" do
    WhoopsLogger.strategies[:rails_exception].service.should == "dummy.web"
  end
  
  it "uses the rails environment for environment by default" do
    WhoopsLogger.strategies[:rails_exception].environment.should == "test"
  end
  
  describe "message modifiers" do  
    let(:message_modifier_names) { WhoopsLogger.strategies[:rails_exception].message_builders.collect{|rm| rm.name} }
    
    it "has a basic details message modifier" do
      message_modifier_names.should include(:basic_details)
    end
    
    
    describe "details"
      it "exists" do
        message_modifier_names.should include(:details)
      end
      
      it "replaces the GEM_HOME path with '$GEM_HOME' in the backtrace" do
        
      end
      
      it "replaces the Rails.root path with '$Rails.root' in the backtrace}" do
    end
    
    it "has a 'create event group identifier' message modifier" do
      message_modifier_names.should include(:create_event_group_identifier)
    end
  end
  
  describe "calling" do
    let(:rack_env) {}
  end
end
