module WhoopsRailsNotifier
  class Railtie < Rails::Railtie
    # config.app_middleware.insert_after "ActionDispatch::Callbacks"
    initializer "whoops_rails_notifier.extend_action_controller_base" do
      config = YAML.load(File.join(Rails.root, "config", "whoops.yml"))[Rails.env]
      WhoopsNotifier.config.set(config)
      WhoopsNotifier.config.logger = Rails.logger
      
      ActionController::Base.send(:include, WhoopsRailsNotifier::ActionControllerCatcher)
      ActionController::Base.send(:include, WhoopsRailsNotifier::ControllerMethods)
    end
  end
end