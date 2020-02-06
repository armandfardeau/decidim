# frozen_string_literal: true

module Decidim
  # A middleware that enhances the request with the current organization based
  # on the hostname.
  class CurrentOrganization
    # Initializes the Rack Middleware.
    #
    # app - The Rack application
    def initialize(app)
      @app = app
    end

    # Main entry point for a Rack Middleware.
    #
    # env - A Hash.
    def call(env)
      host_for(env)
      detect_current_organization
      find_secondary_host_org

      return @app.call(env) if first_install? || localhost?

      if @detect_current_organization
        env["decidim.current_organization"] = @detect_current_organization
        @app.call(env)
      elsif @find_secondary_host_org
        location = new_location_for(env, @find_secondary_host_org.host)

        [301, { "Location" => location, "Content-Type" => "text/html", "Content-Length" => "0" }, []]
      else
        [404, { "Content-Type" => "text/html", "Content-Length" => "0" }, []]
      end
    end

    private

    def first_install?
      Decidim::Organization.count.zero? && no_host?
    end

    def no_host?
      @detect_current_organization.blank? && @find_secondary_host_org.blank?
    end

    # Respond to curl for heartbeat
    def localhost?
      @host == "127.0.0.1" || @host == "localhost"
    end

    def detect_current_organization
      @detect_current_organization = Decidim::Organization.find_by(host: @host)
    end

    def find_secondary_host_org
      @find_secondary_host_org = Decidim::Organization.find_by("? = ANY(secondary_hosts)", @host)
    end

    def host_for(env)
      @host = Rack::Request.new(env).host.downcase
    end

    def new_location_for(env, host)
      request = Rack::Request.new(env)
      url = URI(request.url)
      url.host = host
      url.to_s
    end
  end
end
