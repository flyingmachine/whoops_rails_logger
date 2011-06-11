require 'spec_helper'

describe WhoopsRailsNotifier::ExceptionStrategy do
  it "uses the rails application name for service by default" do
    WhoopsNotifier.strategies[:rails_exception].service.should == "dummy"
  end
  
  it "uses the rails environment for environment by default" do
    WhoopsNotifier.strategies[:rails_exception].environment.should == "test"
  end
  
  describe "report modifiers" do  
    let(:report_modifier_names) { WhoopsNotifier.strategies[:rails_exception].report_modifiers.collect{|rm| rm.name} }
    
    it "has a basic details report modifier" do
      report_modifier_names.should include(:basic_details)
    end
    
    it "has a details report modifier" do
      report_modifier_names.should include(:details)
    end
    
    it "has a 'create event group identifier' report modifier" do
      report_modifier_names.should include(:create_event_group_identifier)
    end
  end
  
  describe "calling" do
    let(:rack_env) {}
  end
end
