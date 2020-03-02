# frozen_string_literal: true

class AddEngineIdToProjects < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :projects, :category
    remove_column :projects, :engine
    add_column :projects, :engine_id, :integer, default: 1
  end

  def self.down
    add_column :projects, :category, :string
    add_column :projects, :engine, :string
    remove_column :projects, :engine_id
  end
end
