# frozen_string_literal: true

class AssociationFieldLoader < AssociationLoader
  def initialize(model, association_name, field)
    @model = model
    @association_name = association_name
    @field = field
    validate
  end

  def read_association(record)
    record.public_send(@association_name).public_send(@field)
  end
end
