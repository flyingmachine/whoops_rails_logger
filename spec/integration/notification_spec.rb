require 'spec_helper'

describe "Notification" do
  include Capybara
  
  def exception_visit(path)
    expect { visit path }.to raise_error
  end
  
  describe "exception notifications while a controller handles a request" do
    before(:all) do
      FakeWeb.register_uri(:post, "http://whoops.com/events/", :body => "success")
    end
    let(:last_request) { FakeWeb.last_request }
    
    it "sends a notification when an exception happens in a controller action" do
      exception_visit(users_path)
      last_request.body.should include("exception in index")
    end
    
    it "sends a notification when an exception happens in a view" do
      exception_visit(new_user_path)
      last_request.body.should include("exception in view")
    end
    
    it "sends a notification when an exception happens in a model" do
      user = User.create
      exception_visit(user_path(user))
      last_request.body.should include("exception in model")
    end
  end
  
end
