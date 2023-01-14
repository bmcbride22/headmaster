class AddAttrToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :description, :text
    add_column :courses, :title, :string, null: false
  end
end
