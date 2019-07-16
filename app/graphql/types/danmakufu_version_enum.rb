# frozen_string_literal: true

module Types
  class DanmakufuVersionEnum < Types::BaseEnum
    DanmakufuVersion.all.each do |version|
      value(version.name_as_enum, version.name, value: version.id)
    end
  end
end
