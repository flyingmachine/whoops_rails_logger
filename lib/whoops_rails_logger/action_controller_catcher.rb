module WhoopsRailsLogger
  module ActionControllerCatcher
    # Sets up an alias chain to catch exceptions when Rails does
    def self.included(base) #:nodoc:
      # base.send(:alias_method, :rescue_action_in_public_without_whoops, :rescue_action_in_public)
      # base.send(:alias_method, :rescue_action_in_public, :rescue_action_in_public_with_whoops)
    end

    private

    # Overrides the rescue_action method in ActionController::Base, but does not inhibit
    # any custom processing that is defined with Rails 2's exception helpers.
    def rescue_action_in_public_with_whoops(exception)        
      evidence = {:exception => exception}.merge(whoops_request_data)
       WhoopsRailsLogger.notify(evidence)
      rescue_action_in_public_without_whoops(exception)
    end
  end
end
