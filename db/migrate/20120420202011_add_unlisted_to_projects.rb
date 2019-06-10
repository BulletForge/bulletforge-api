# frozen_string_literal: true

class AddUnlistedToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :unlisted, :boolean, default: false
  end

  def self.down
    remove_column :projects, :unlisted
  end
end
