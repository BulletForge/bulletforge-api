module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false

    def users
      User.all
    end

    field :user, Types::UserType, null: false do
      argument :permalink, String, required: true
    end

    def user(permalink:)
      User.find_by_permalink(permalink)
    end

    field :projects, [Types::ProjectType], null: false

    def projects
      Project.all
    end
  end
end
