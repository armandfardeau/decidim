# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class FooterSubHeroCell < Decidim::ViewModel
      include Decidim::IconHelper

      delegate :current_user, to: :controller
    end

    private

    def cacheable?
      true
    end
  end
end
