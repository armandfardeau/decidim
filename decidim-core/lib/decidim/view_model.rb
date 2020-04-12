# frozen_string_literal: true

module Decidim
  class ViewModel < Cell::ViewModel
    include ActionView::Helpers::TranslationHelper
    include ::Cell::Translation
    include Decidim::ResourceHelper
    include Decidim::ScopesHelper
    include ActionController::Helpers
    include Decidim::ActionAuthorization
    include Decidim::ActionAuthorizationHelper
    include Decidim::ReplaceButtonsHelper
    include Cell::Caching::Notifications
    cache :show, expires_in: Decidim.homepage_cache_expiration_time, if: :cacheable?

    delegate :current_organization, to: :controller

    def current_user
      context&.dig(:current_user) || controller&.current_user
    end

    private

    def decidim
      Decidim::Core::Engine.routes.url_helpers
    end

    def cacheable?
      false
    end
  end
end
