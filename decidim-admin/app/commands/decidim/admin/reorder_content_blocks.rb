# frozen_string_literal: true

module Decidim
  module Admin
    # A command that reorders a collection of content blocks.
    class ReorderContentBlocks < Rectify::Command
      # Public: Initializes the command.
      #
      # collection - an ActiveRecord::Relation of content blocks. Should include
      #   both the published and unpublished content blocks for a given scope.
      # order - an Array holding the order of IDs of published content blocks.
      def initialize(collection, order)
        @collection = collection
        @order = order
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the data wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if order.blank?

        reorder_steps
        broadcast(:ok)
      end

      private

      attr_reader :collection

      def reorder_steps
        data = order.each_with_index.inject({}) do |hash, (id, index)|
          hash.update(id => { weight: index })
        end

        # rubocop:disable Rails/SkipsModelValidations
        transaction do
          collection.update_all(weight: nil)
          collection.reload
          collection.update(data.keys, data.values)
          collection.where(weight: nil).update_all(published_at: nil)
          collection.where(published_at: nil).where.not(weight: nil).update_all(published_at: Time.current)
        end
        # rubocop:enable Rails/SkipsModelValidations
      end

      def order
        return nil unless @order.is_a?(Array) && @order.present?

        @order
      end
    end
  end
end
