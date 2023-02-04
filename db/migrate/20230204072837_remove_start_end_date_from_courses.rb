class RemoveStartEndDateFromCourses < ActiveRecord::Migration[7.0]
  def change
    remove_column :courses, :start_date, :date
    remove_column :courses, :end_date, :date
  end
end
