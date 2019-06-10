# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false

    def users
      User.all
    end

    field :user, Types::UserType, null: false do
      argument :id, String, required: true
    end

    def user(id:)
      User.find_by_permalink(id)
    end

    field :projects, [Types::ProjectType], null: false

    def projects
      Project.all
    end
  end
end
