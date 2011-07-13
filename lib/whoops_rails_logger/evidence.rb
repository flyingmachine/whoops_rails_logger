module WhoopsRailsLogger
  class Evidence
    attr_accessor :exception
    attr_accessor :url
    
    def initialize(exception, rack)
      self.exception    = exception
      self.rack         = rack
      self.url          = args[:url] || rack_env(:url)

      self.parameters          = args[:parameters] ||
                                   action_dispatch_params ||
                                   rack_env(:params) ||
                                   {}
      self.component           = args[:component] || args[:controller] || parameters['controller']
      self.action              = args[:action] || parameters['action']

      self.environment_name = args[:environment_name]
      self.cgi_data         = args[:cgi_data] || args[:rack_env]
      self.backtrace        = Backtrace.parse(exception_attribute(:backtrace, caller), :filters => self.backtrace_filters)
      self.error_class      = exception_attribute(:error_class) {|exception| exception.class.name }
      self.error_message    = exception_attribute(:error_message, 'Notification') do |exception|
    end
    
    def action_dispatch_params
      rack[:rack_env]['action_dispatch.request.parameters'] if rack
    end
  end
end
