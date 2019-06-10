# frozen_string_literal: true

class BulletforgeApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
