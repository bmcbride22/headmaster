class AddCurrentToSemesters < ActiveRecord::Migration[7.0]
  def change
    add_column :semesters, :current, :boolean, default: false
  end
end
