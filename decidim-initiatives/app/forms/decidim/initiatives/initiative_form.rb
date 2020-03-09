# frozen_string_literal: true

module Decidim
  module Initiatives
    # A form object used to collect the data for a new initiative.
    class InitiativeForm < Form
      include TranslatableAttributes

      mimic :initiative

      attribute :title, String
      attribute :description, String
      attribute :type_id, Integer
      attribute :scope_id, Integer
      attribute :decidim_user_group_id, Integer
      attribute :signature_type, String
      attribute :state, String
      attribute :attachment, AttachmentForm

      validates :title, :description, presence: true
      validates :title, length: { maximum: 150 }
      validates :signature_type, presence: true
      validates :type_id, presence: true
      validate :scope_exists
      validate :notify_missing_attachment_if_errored

      def map_model(model)
        self.type_id = model.type.id
        self.scope_id = model.scope&.id
      end

      def signature_type_updatable?
        state == "created" || state.nil?
      end

      def scope_id
        super.presence
      end

      private

      def scope_exists
        return if scope_id.blank?

        errors.add(:scope_id, :invalid) unless InitiativesTypeScope.where(decidim_initiatives_types_id: type_id, decidim_scopes_id: scope_id).exists?
      end

      # This method will add an error to the `attachment` field only if there's
      # any error in any other field. This is needed because when the form has
      # an error, the attachment is lost, so we need a way to inform the user of
      # this problem.
      def notify_missing_attachment_if_errored
        errors.add(:attachment, :needs_to_be_reattached) if errors.any? && attachment.present?
      end
    end
  end
end
