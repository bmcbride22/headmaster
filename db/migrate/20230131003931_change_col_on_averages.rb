class ChangeColOnAverages < ActiveRecord::Migration[7.0]
  def change
    change_column_null :averages, :unit_id, true
    add_column :averages, :section_avg, :boolean, default: false
    add_column :averages, :unit_avg, :boolean, default: false
    add_column :averages, :course_avg, :boolean, default: false
  end
end
