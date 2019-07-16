# frozen_string_literal: true

module Mutations
  class CreateDraftProject < Mutations::BaseMutation
    null true

    argument :title, String, 'Title for the project', required: false

    field :project, Types::ProjectType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def resolve(title: 'Untitled')
      project = new_draft_project(title)

      if project.save
        success_response(project)
      else
        add_model_errors(project)
        error_response
      end
    end

    private

    def new_draft_project(title)
      Project.new(
        title: title,
        user: context[:current_user],
        category: Category.first,
        danmakufu_version: DanmakufuVersion.first,
        draft: true
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
