module WhoopsRailsNotifier
  class ExceptionStrategy < WhoopsNotifier::Strategy
    attr_accessor :service, :environment
    def initialize(strategy_name)
      super
      
      self.service     = ::Rails.application.class.name.split("::").first.downcase
      self.environment = ::Rails.env
      
      add_basic_details_report_modifier
    end
    
    def add_basic_details_report_modifier
      self.add_report_modifier(:basic_details) do |report, evidence|
        report.service     = self.service
        report.environment = selv.environment
      end
    end
  end
end