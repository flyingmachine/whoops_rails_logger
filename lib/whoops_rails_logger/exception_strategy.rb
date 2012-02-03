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

        details[:http_host]      = rack_env["HTTP_HOST"]        
        details[:params]         = rack_env["action_dispatch.request.parameters"]
        details[:controller]     = details[:params][:controller] if details[:params]
        details[:action]         = details[:params][:action]     if details[:params]
        details[:query_string]   = rack_env["QUERY_STRING"]
        details[:remote_addr]    = rack_env["REMOTE_ADDR"]
        details[:request_method] = rack_env["REQUEST_METHOD"]
        details[:server_name]    = rack_env["SERVER_NAME"]
        details[:session]        = rack_env["rack.session"]
        details[:env]            = ENV.to_hash
        message.details          = details
      end

      self.add_message_builder(:create_event_group_identifier) do |message, raw_data|
        identifier = "#{message.details[:controller]}##{message.details[:action]} #{message.message}"
        identifier << message.details[:backtrace].first.gsub(/:in.*/, "")
        message.event_group_identifier = Digest::MD5.hexdigest(identifier)
      end
    end
  end
end
