# frozen_string_literal: true

module Types
  class ProjectSort < Types::BaseEnum
    value 'CREATION_TIME', value: :created_at
    value 'DOWNLOADS', value: :downloads
  end
end
