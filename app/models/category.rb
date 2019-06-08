# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :projects

  def self.select_array
    all.collect do |cat|
      [cat.name, cat.id]
    end
  end
end
