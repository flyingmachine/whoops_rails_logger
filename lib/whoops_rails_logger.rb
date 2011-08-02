require "digest"
require "whoops_logger"
require "whoops_rails_logger/exception_strategy"
require "whoops_rails_logger/rack"
require "whoops_rails_logger/railtie"

module WhoopsRailsLogger
  def self.initialize
    configure
    create_exception_strategy
  end
  
  def self.configure
    config_path = File.join(Rails.root, "config", "whoops_logger.yml")
    
    unless File.exists?(config_path)
      raise "Please create config/whoops_logger.yml"
    end
    
    config = YAML.load_file(config_path)[Rails.env]
    WhoopsLogger.config.set(config)
    WhoopsLogger.config.logger = Rails.logger
  end
  
  def self.create_exception_strategy
    strategy = WhoopsRailsLogger::ExceptionStrategy.new(:rails_exception)
  end  
end