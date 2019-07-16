class AddDraftToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :draft, :boolean, default: false
  end
end
