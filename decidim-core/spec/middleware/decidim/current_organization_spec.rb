# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe CurrentOrganization do
    let(:app) { ->(env) { [200, env, "app"] } }
    let(:env) { Rack::MockRequest.env_for("https://#{host}/a?foo=bar", {}) }
    let(:host) { "city.domain.org" }
    let(:middleware) { described_class.new(app) }

    context "when an organization exists for the current host" do
      let!(:organization) { create(:organization, host: host) }

      it "sets the organization" do
        _code, new_env = middleware.call(env)

        expect(new_env["decidim.current_organization"]).to eq(organization)
      end
    end

    context "when no organization exists for the current host" do
      let!(:organization) { create(:organization) }

      context "when an organization exists with the current host as secondary host" do
        let(:host) { "blah.lvh.me" }
        let!(:organization) { create(:organization, host: "fake.host.com", secondary_hosts: [host]) }

        it "redirects the user to the primary host of the detected organization" do
          code, new_env = middleware.call(env)

          expect(new_env["Location"]).to eq("https://fake.host.com/a?foo=bar")
          expect(code).to eq(301)
        end
      end

      it "displays a 404 error" do
        code, _new_env = middleware.call(env)

        expect(code).to eq(404)
      end

      it "doesn't set the organization" do
        _code, new_env = middleware.call(env)

        expect(new_env["decidim.current_organization"]).to be_nil
      end
    end

    context "when no organization exists" do
      let(:host) { "evil.lvh.me" }

      it "redirects the user to the primary host of the detected organization" do
        expect(app).to receive(:call).with(env)
        middleware.call(env)
      end
    end
  end
end
