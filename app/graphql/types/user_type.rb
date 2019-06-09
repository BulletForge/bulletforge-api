module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :permalink, String, null: true
    field :email, String, null: true
    field :login, String, null: true
    field :projects, [Types::ProjectType], null: true
    field :projects_count, Integer, null: true

    def projects_count
      projects.size
    end
  end
end
