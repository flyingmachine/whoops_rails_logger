require "digest"
require "whoops_notifier"
require "whoops_rails_notifier/action_controller_catcher"
require "whoops_rails_notifier/controller_methods"
require "whoops_rails_notifier/railtie"

module WhoopsRailsNotifier
  def self.initialize
    configure
    create_controller_strategy
  end
  
  def self.configure
    WhoopsNotifier.config.logger = Rails.logger
  end
  
  def self.create_controller_strategy
    strategy = WhoopsNotifier::Strategy.new(:rails)
    strategy.add_report_modifier(:create_report_from_evidence) do |report, evidence|
      exception   = evidence[:exception]
      request     = evidence[:request]
      params      = evidence[:params]
      environment = evidence[:environment]

      report.event_type  = "exception"
      report.service     = Rails.application.name
      report.environment = Rails.env
      report.message     = exception.message
      report.event_time  = Time.now
      report.details     = evidence.except(:exception)
    end

    strategy.add_report_modifier(:create_event_group_identifier) do |report, evidence|
      identifer = "#{evidence[:controller]}##{evidence[:action]}"
      identifier << evidence[:exception].backtrace.collect{|l| l.sub(Rails.root, "")}.join("\n")
      report.event_group_identifier = Digest::MD5.hexdigest(identifier)
    end
  end
  
  def self.create_rack_strategy
  end
end

WhoopsRailsNotifier.initialize