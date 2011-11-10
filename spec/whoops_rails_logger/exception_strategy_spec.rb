require 'spec_helper'

describe WhoopsRailsLogger::ExceptionStrategy do
  let(:rails_exception_strategy) { WhoopsLogger.strategies[:rails_exception] }
  it "uses the rails application name for service by default" do
    rails_exception_strategy.service.should == "dummy.web"
  end
  
  it "uses the rails environment for environment by default" do
    rails_exception_strategy.environment.should == "test"
  end
  
  describe "message modifiers" do  
    let(:message_modifier_names) { rails_exception_strategy.message_builders.collect{|rm| rm.name} }
    
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
    let(:rack_env) do
      {
        "action_dispatch.request.parameters"              => {"action"=> "index", "controller"=> "users"},
        "rack.session"                                    => {"session_id"=> "228485465ee77bea799ee293889dd493", "session_test"=> "abra"},
        "rack.test"                                       => true,
        "HTTP_HOST"                                       => "www.example.com",
        "SERVER_NAME"                                     => "www.example.com",
        "rack.request.cookie_hash"                        => {},
        "CONTENT_LENGTH"                                  => "0",
        "rack.url_scheme"                                 => "http",
        "action_dispatch.request.query_parameters"        => {},
        "action_dispatch.request.unsigned_session_cookie" => {"session_id"=> "228485465ee77bea799ee293889dd493"},
        "HTTPS"                                           => "off",
        "action_dispatch.secret_token"                    =>
          "55af9bff3509c731697b16a8bdc0111a1291deef99653fbf5f174c1fbbeb400bffe3f8f1f46e40f529df264bd6a30d77ecf8cb300a2945e6706d61c69aa5e853",
        "REMOTE_ADDR"                                     => "127.0.0.1",
        "PATH_INFO"                                       => "/users",
        "rack.version"                                    => [1, 1],
        "rack.run_once"                                   => false,
        "action_dispatch.request.path_parameters"         => {:controller => "users", :action=> "index"},
        "rack.request.cookie_string"                      => "",
        "SCRIPT_NAME"                                     => "",
        "action_dispatch.parameter_filter"                => [:password],
        "action_dispatch.show_exceptions"                 => false,
        "HTTP_COOKIE"                                     => "",
        "rack.multithread"                                => false,
        "action_dispatch.request.request_parameters"      => {},
        "action_dispatch.cookies"                         => {},
        "rack.multiprocess"                               => true,
        "rack.request.query_hash"                         => {},
        "SERVER_PORT"                                     => "80",
        "rack.session.options"                            =>
        {
          :secure                                         => false,
          :expire_after                                   => nil,
          :path                                           => "/",
          :httponly                                       => true,
          :domain                                         => nil,
          :id                                             => "228485465ee77bea799ee293889dd493"
        },
        "REQUEST_METHOD"                                  => "GET",
        "rack.request.query_string"                       => "",
        "action_dispatch.request.content_type"            => nil,
        "QUERY_STRING"                                    => ""
      }
    end
    
    let(:exception) do
      begin
        raise StandardError.new("What an exception!")
      rescue => e
        e
      end
    end
    
    let(:raw_data) do
      {
        :exception => exception,
        :rack_env  => rack_env
      }
    end
    
    it "populates details correctly" do
      mc = WhoopsLogger::MessageCreator.new(rails_exception_strategy, raw_data)
      mc.create!
      mc.message.details[:http_host].should      == rack_env["HTTP_HOST"]        
      mc.message.details[:params].should         == rack_env["action_dispatch.request.parameters"]
      mc.message.details[:query_string].should   == rack_env["QUERY_STRING"]
      mc.message.details[:remote_addr].should    == rack_env["REMOTE_ADDR"]
      mc.message.details[:request_method].should == rack_env["REQUEST_METHOD"]
      mc.message.details[:server_name].should    == rack_env["SERVER_NAME"]
      mc.message.details[:session].should        == rack_env["rack.session"]
      mc.message.details[:env].should            == ENV.to_hash
    end
    
    it "creates the same event group identifier when backtraces have the same sequence of file/line numbers, ignoring method name" do
      exception.stub!(:backtrace).and_return([
        "$GEM_HOME/gems/activesupport-3.1.1/lib/active_support/callbacks.rb:386:in `_run123_process_action_callbacks'"
      ])
      mc1 = WhoopsLogger::MessageCreator.new(rails_exception_strategy, raw_data)
      mc1.create!
      
      exception.stub!(:backtrace).and_return([
        "$GEM_HOME/gems/activesupport-3.1.1/lib/active_support/callbacks.rb:386:in `_run456_process_action_callbacks'"
      ])
      mc2 = WhoopsLogger::MessageCreator.new(rails_exception_strategy, raw_data)
      mc2.create!
      
      mc1.message.event_group_identifier.should == mc2.message.event_group_identifier
    end
  end
end
