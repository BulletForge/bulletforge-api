# frozen_string_literal: true

module Mutations
  class CreateProject < Mutations::BaseMutation
    null true

    argument :title, String, required: true
    argument :description, String, required: false
    argument :category, Types::CategoryEnum, as: :category_id, required: true
    argument :danmakufu_version, Types::DanmakufuVersionEnum, as: :danmakufu_version_id, required: true
    argument :signed_blob_id, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def resolve(title:, description:, danmakufu_version_id:, category_id:, signed_blob_id:)
      project = new_project(title, description, danmakufu_version_id, category_id, signed_blob_id)

      if project.save
        success_response(project)
      else
        add_model_errors(project)
        error_response
      end
    end

    private

    def new_project(title, description, danmakufu_version_id, category_id, signed_blob_id)
      Project.new(
        title: title,
        description: description,
        user: current_user,
        category_id: category_id,
        danmakufu_version_id: danmakufu_version_id,
        archive: signed_blob_id
      )
    end

    def success_response(project)
      {
        project: project,
        errors: []
      }
    end

    def error_response
      {
        project: nil,
        errors: user_errors
      }
    end
  end
end
