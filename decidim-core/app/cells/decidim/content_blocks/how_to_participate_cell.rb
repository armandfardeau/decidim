# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class HowToParticipateCell < Decidim::ViewModel
      include Decidim::IconHelper
    end

    private

    def cacheable?
      true
    end
  end
end
