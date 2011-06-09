module WhoopsNotifierRails
  module ControllerMethods
    private

    # This method should be used for sending manual notifications while you are still
    # inside the controller. Otherwise it works like WhoopsNotifierRails.notify.
    def notify_whoops(exception)
      evidence = {:exception => exception}.merge(whoops_request_data)
      WhoopsNotifierRails.notify(:rails, evidence)
    end

    def whoops_request_data
      { :parameters       => whoops_filter_if_filtering(params.to_hash),
        :session_data     => whoops_filter_if_filtering(whoops_session_data),
        :controller       => params[:controller],
        :action           => params[:action],
        :url              => whoops_request_url,
        :cgi_data         => whoops_filter_if_filtering(request.env) }
    end

    def whoops_filter_if_filtering(hash)
      return hash if ! hash.is_a?(Hash)

      if respond_to?(:filter_parameters)
        filter_parameters(hash) rescue hash
      else
        hash
      end
    end

    def whoops_session_data
      if session.respond_to?(:to_hash)
        session.to_hash
      else
        session.data
      end
    end

    def whoops_request_url
      url = "#{request.protocol}#{request.host}"

      unless [80, 443].include?(request.port)
        url << ":#{request.port}"
      end

      url << request.request_uri
      url
    end
  end
end