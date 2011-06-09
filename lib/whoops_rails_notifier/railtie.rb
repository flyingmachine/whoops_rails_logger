module WhoopsRailsNotifier
  class Railtie < Rails::Railtie
    # config.app_middleware.insert_after "ActionDispatch::Callbacks"
    initializer "whoops_rails_notifier.extend_action_controller_base" do
      ActionController::Base.send(:include, WhoopsRailsNotifier::ActionControllerCatcher)
      ActionController::Base.send(:include, WhoopsRailsNotifier::ControllerMethods)
    end
  end
end