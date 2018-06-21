# frozen_string_literal: true

module Decidim
  module Meetings
    MeetingMetricType = GraphQL::ObjectType.define do
      interfaces [-> { Decidim::Meetings::MeetingMetricInterface }]

      name "MeetingMetricType"
      description "A meeting component of a participatory space."
    end

    module MeetingMetricTypeHelper
      def self.base_scope(_organization)
        # super(organization).accepted
        Meeting.includes(:scope).all
      end
    end
  end
end
