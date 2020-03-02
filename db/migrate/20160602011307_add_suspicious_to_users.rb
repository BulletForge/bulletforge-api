# frozen_string_literal: true

class AddSuspiciousToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :suspicious, :boolean, default: false
  end

  def self.down
    remove_column :users, :suspicious
  end
end
