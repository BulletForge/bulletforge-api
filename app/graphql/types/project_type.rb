module Types
  class ProjectType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: true
    field :description, String, null: true
    field :version, String, null: true
  end
end
