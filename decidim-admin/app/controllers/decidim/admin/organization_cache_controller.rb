# frozen_string_literal: true

module Decidim
  module Admin
    # Controller that allows managing the organization homepage
    class OrganizationCacheController < Decidim::Admin::ApplicationController
      layout "decidim/admin/settings"

      def edit
        enforce_permission_to :update, :organization, organization: current_organization
      end

      def update
        enforce_permission_to :update, :organization, organization: current_organization

        if Rails.cache.clear.zero?
          flash[:success] = t(".clear_cache_success")
        else
          flash[:alert] = t(".clear_cache_alert")
        end

        redirect_to edit_organization_cache_path
      end
    end
  end
end
