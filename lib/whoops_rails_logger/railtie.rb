module WhoopsRailsLogger
  class Railtie < Rails::Railtie
    # config.app_middleware.insert_after "ActionDispatch::Callbacks"
    config.app_middleware.use WhoopsRailsLogger::Rack
    
    config.after_initialize do
      WhoopsRailsLogger.initialize
    end
  end
end