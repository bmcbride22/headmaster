class AddDescriptionToModels < ActiveRecord::Migration[7.0]
  def change
    add_column :syllabuses, :description, :text
    add_column :cohorts, :description, :text
    add_column :assessments, :description, :text
  end
end
