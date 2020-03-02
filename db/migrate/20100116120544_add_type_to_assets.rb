# frozen_string_literal: true

class AddTypeToAssets < ActiveRecord::Migration[5.2]
  def self.up
    add_column :assets, :type, :string
  end

  def self.down
    remove_column :assets, :type, :string
  end
end
