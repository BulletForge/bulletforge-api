# frozen_string_literal: true

class DanmakufuVersion < ApplicationRecord
  has_many :projects

  def name_as_enum
    'V_' + name.upcase.gsub('.', '_')
  end
end
