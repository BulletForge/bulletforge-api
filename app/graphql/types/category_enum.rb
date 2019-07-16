# frozen_string_literal: true

module Types
  class CategoryEnum < Types::BaseEnum
    Category.all.each do |category|
      value(category.name_as_enum, category.name, value: category.id)
    end
  end
end
