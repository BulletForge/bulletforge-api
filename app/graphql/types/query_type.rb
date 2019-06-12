# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, Types::UserType.connection_type, null: false

    def users
      User.all
    end

    field :user, Types::UserType, null: false do
      argument :id, String, required: true
    end

    def user(id:)
      User.friendly.find(id)
    end

    field :projects, Types::ProjectType.connection_type, null: false

    def projects
      Project.all
    end
  end
end
