# copied from Rails https://github.com/rails/rails/blob/2468b161a6ada171cceeddaf418b540eb98f2d55/actionpack/lib/action_dispatch/middleware/ssl.rb#L9
# Add support for excluded_paths
class ForceSslMiddleware
  YEAR = 31536000

  def self.default_hsts_options
    { :expires => YEAR, :subdomains => false }
  end

  def initialize(app, options = {})
    @app = app

    @hsts = options.fetch(:hsts, {})
    @hsts = {} if @hsts == true
    @hsts = self.class.default_hsts_options.merge(@hsts) if @hsts

    @host = options[:host]
    @port = options[:port]

    @excluded_paths = options[:excluded_paths]
    validate_excluded_paths
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    if excluded_path?(request.fullpath)
      @app.call(env)
    else
      if request.ssl?
        status, headers, body = @app.call(env)
        headers.reverse_merge!(hsts_headers)
        flag_cookies_as_secure!(headers)
        [status, headers, body]
      else
        redirect_to_https(request)
      end
    end
  end

  private
    def redirect_to_https(request)
      host = @host || request.host
      port = @port || request.port

      location = "https://#{host}"
      location << ":#{port}" if port != 80
      location << request.fullpath

      headers = { 'Content-Type' => 'text/html', 'Location' => location }

      [301, headers, []]
    end

    # http://tools.ietf.org/html/draft-hodges-strict-transport-sec-02
    def hsts_headers
      if @hsts
        value = "max-age=#{@hsts[:expires].to_i}"
        value += "; includeSubDomains" if @hsts[:subdomains]
        { 'Strict-Transport-Security' => value }
      else
        {}
      end
    end

    def flag_cookies_as_secure!(headers)
      if cookies = headers['Set-Cookie']
        cookies = cookies.split("\n")

        headers['Set-Cookie'] = cookies.map { |cookie|
          if cookie !~ /;\s*secure\s*(;|$)/i
            "#{cookie}; secure"
          else
            cookie
          end
        }.join("\n")
      end
    end

    def excluded_path?(path)
      string_paths, other_paths = @excluded_paths.partition {|p| p.is_a?(String)}
      if string_paths.present? && path.start_with?(*string_paths)
        true
      else
        other_paths.any? do |excluded_path|
          path =~ excluded_path
        end
      end
    end

    def validate_excluded_paths
      if @excluded_paths.any? {|p| !p.is_a?(String) && !p.is_a?(Regexp)}
        raise "only String and Regexp supported for excluded_paths"
      end
    end
end
