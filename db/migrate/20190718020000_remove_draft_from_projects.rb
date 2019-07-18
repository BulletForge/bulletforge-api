class RemoveDraftFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :draft
  end
end
