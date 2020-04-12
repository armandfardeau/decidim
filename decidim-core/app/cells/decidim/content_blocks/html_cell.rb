# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class HtmlCell < Decidim::ViewModel
      def html_content
        translated_attribute(model.settings.html_content).html_safe
      end

      private

      def cacheable?
        true
      end
    end
  end
end
