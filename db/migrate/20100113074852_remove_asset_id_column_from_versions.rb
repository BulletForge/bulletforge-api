# frozen_string_literal: true

class RemoveAssetIdColumnFromVersions < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :versions, :asset_id
  end

  def self.down
    add_column :versions, :asset_id, :integer
  end
end
