module WhoopsRailsLogger
  # Middleware for Rack applications. Any errors raised by the upstream
  # application will be delivered to whoops and re-raised.
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => raised
        evidence = {
          :exception => raised,
          :rack_env  => env
        }
        WhoopsLogger.notify(:rails_exception, evidence)
        raise
      end

      response
    end
  end
end
