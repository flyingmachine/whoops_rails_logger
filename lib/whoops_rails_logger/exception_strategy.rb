module WhoopsRailsLogger
  class ExceptionStrategy < WhoopsLogger::Strategy
    attr_accessor :service, :environment
    def initialize(strategy_name)
      super
      
      self.service     = ::Rails.application.class.name.split("::").first.downcase + ".web"
      self.environment = ::Rails.env
      
      add_message_builders
    end
    
    def add_message_builders
      self.add_message_builder(:basic_details) do |message, raw_data|
        message.service     = self.service
        message.environment = self.environment
        message.event_type  = "exception"
        message.message     = raw_data[:exception].message
        message.event_time  = Time.now
      end
      
      self.add_message_builder(:details) do |message, raw_data|
        exception = raw_data[:exception]
        rack_env  = raw_data[:rack_env]
        
        details = {}
        details[:backtrace] = exception.backtrace.collect{ |line|
          line.sub(/^#{ENV['GEM_HOME']}/, '$GEM_HOME').sub(/^#{Rails.root}/, '$Rails.root')
        }
        details[:params]    = rack_env["action_dispatch.request.parameters"]
        message.details      = details
      end

      self.add_message_builder(:create_event_group_identifier) do |message, raw_data|
        identifier = "#{raw_data[:controller]}##{raw_data[:action]}"
        identifier << raw_data[:exception].backtrace.collect{|l| l.sub(Rails.root, "")}.join("\n")
        message.event_group_identifier = Digest::MD5.hexdigest(identifier)
      end
    end
  end
end