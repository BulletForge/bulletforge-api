# frozen_string_literal: true

class BulletforgeApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  use GraphQL::Batch

  def self.id_from_object(object, _type_definition, _query_ctx)
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  end

  def self.object_from_id(id, _query_ctx)
    class_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
    RecordLoader.for(Object.const_get(class_name)).load(item_id)
  end

  def self.resolve_type(_type, obj, _ctx)
    case obj
    when User
      Types::UserType
    when Project
      Types::ProjectType
    else
      raise("Unexpected object: #{obj}")
    end
  end
end
