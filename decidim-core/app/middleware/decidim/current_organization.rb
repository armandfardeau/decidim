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
      detect_current_organization(env)
      find_secondary_host_org(env)

      return @app.call(env) if Decidim::Organization.count.zero? && @detect_current_organization.blank? && @find_secondary_host_org.blank?
      return [404, { "Content-Type" => "text/html", "Content-Length" => "0" }, []] if @detect_current_organization.blank? && @find_secondary_host_org.blank?

      if @detect_current_organization
        env["decidim.current_organization"] = @detect_current_organization
        @app.call(env)
      else
        location = new_location_for(env, @find_secondary_host_org.host)

        [301, { "Location" => location, "Content-Type" => "text/html", "Content-Length" => "0" }, []]
      end
    end

    private

    def detect_current_organization(env)
      host = host_for(env)
      @detect_current_organization = Decidim::Organization.find_by(host: host)
    end

    def find_secondary_host_org(env)
      host = host_for(env)
      @find_secondary_host_org = Decidim::Organization.find_by("? = ANY(secondary_hosts)", host)
    end

    def host_for(env)
      Rack::Request.new(env).host.downcase
    end

    def new_location_for(env, host)
      request = Rack::Request.new(env)
      url = URI(request.url)
      url.host = host
      url.to_s
    end
  end
end
