# frozen_string_literal: true

module Types
  class SortDirection < Types::BaseEnum
    value 'asc', 'sort by ascending order'
    value 'desc', 'sort by descending order'
  end
end
