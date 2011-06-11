module WhoopsRailsNotifier
  class ExceptionStrategy < WhoopsNotifier::Strategy
    attr_accessor :service, :environment
    def initialize(strategy_name)
      super
      
      self.service     = ::Rails.application.class.name.split("::").first.downcase
      self.environment = ::Rails.env
      
      add_report_modifiers
    end
    
    def add_report_modifiers
      self.add_report_modifier(:basic_details) do |report, evidence|
        report.service     = self.service
        report.environment = self.environment
        report.event_type  = "exception"
        report.message     = evidence[:exception].message
        report.event_time  = Time.now
      end
      
      self.add_report_modifier(:details) do |report, evidence|
        exception = evidence[:exception]
        rack_env  = evidence[:rack_env]
        
        details = {}
        details[:backtrace] = exception.backtrace
        report.details      = details
      end

      self.add_report_modifier(:create_event_group_identifier) do |report, evidence|
        identifier = "#{evidence[:controller]}##{evidence[:action]}"
        identifier << evidence[:exception].backtrace.collect{|l| l.sub(Rails.root, "")}.join("\n")
        report.event_group_identifier = Digest::MD5.hexdigest(identifier)
      end
    end
  end
end