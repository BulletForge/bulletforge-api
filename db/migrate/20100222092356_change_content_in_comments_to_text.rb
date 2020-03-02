# frozen_string_literal: true

class ChangeContentInCommentsToText < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :comments, :content
    add_column :comments, :content, :text
  end

  def self.down
    remove_column :comments, :content
    add_column :comments, :content, :string
  end
end
