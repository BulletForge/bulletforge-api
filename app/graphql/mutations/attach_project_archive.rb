# frozen_string_literal: true

module Mutations
  class AttachProjectArchive < Mutations::BaseMutation
    null true

    argument :project_id, ID, required: true, loads: Types::ProjectType
    argument :blob_id, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def authorize?(**args)
      authorize AttachProjectArchivePolicy.new(current_user, args[:project])
      super(**args)
    end

    def resolve(project:, blob_id:)
      project.archive.attach(blob_id)
      {
        project: project,
        errors: []
      }
    end

    private

    def error_response
      { project: nil }.merge(super)
    end
  end
end
