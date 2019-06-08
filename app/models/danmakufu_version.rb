# frozen_string_literal: true

class DanmakufuVersion < ApplicationRecord
  has_many :projects

  def self.select_array
    all.collect do |ver|
      [ver.name, ver.id]
    end
  end
end
