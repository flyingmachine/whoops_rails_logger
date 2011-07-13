require "digest"
require "whoops_notifier"
require "whoops_rails_notifier/action_controller_catcher"
require "whoops_rails_notifier/controller_methods"
require "whoops_rails_notifier/exception_strategy"
require "whoops_rails_notifier/rack"
require "whoops_rails_notifier/railtie"

module WhoopsRailsLogger
  def self.initialize
    configure
    create_exception_strategy
  end
  
  def self.configure
    config = YAML.load_file(File.join(Rails.root, "config", "whoops.yml"))[Rails.env]
    WhoopsLogger.config.set(config)
    WhoopsLogger.config.logger = Rails.logger
  end
  
  def self.create_exception_strategy
    strategy = WhoopsRailsLogger::ExceptionStrategy.new(:rails_exception)
  end  
end