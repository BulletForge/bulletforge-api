# frozen_string_literal: true

module Mutations
  class UpdateProject < Mutations::BaseMutation
    null true

    argument :project_id, ID, required: true, loads: Types::ProjectType
    argument :title, String, required: false
    argument :description, String, required: false
    argument :draft, Boolean, required: false
    argument :category, Types::CategoryEnum, as: :category_id, required: false
    argument :danmakufu_version, Types::DanmakufuVersionEnum, as: :danmakufu_version_id, required: false

    field :project, Types::ProjectType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def authorized?(project:, **args)
      authorize UpdateProjectPolicy.new(context[:current_user], project)
      super(**args)
    end

    def resolve(project:, **args)
      if project.update(args)
        success_response(project)
      else
        add_model_errors(project)
        error_response
      end
    end

    private

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
