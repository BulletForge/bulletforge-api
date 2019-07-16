# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :projects

  def name_as_enum
    name.upcase.gsub(/[ .-]+/, '_')
  end
end
