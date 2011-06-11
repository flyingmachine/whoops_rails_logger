module WhoopsRailsNotifier
  class Railtie < Rails::Railtie
    # config.app_middleware.insert_after "ActionDispatch::Callbacks"
    config.app_middleware.use WhoopsRailsNotifier::Rack
    
    config.after_initialize do
      WhoopsRailsNotifier.initialize
      ::ActionController::Base.send(:include, WhoopsRailsNotifier::ControllerMethods)
    end
  end
end