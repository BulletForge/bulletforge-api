# frozen_string_literal: true

class AddAdminFieldToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :admin, :boolean
  end

  def self.down
    remove_column :users, :admin
  end
end
