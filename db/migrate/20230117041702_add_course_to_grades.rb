class AddCourseToGrades < ActiveRecord::Migration[7.0]
  def change
    add_reference :grades, :course, null: false, foreign_key: true
    add_column :grades, :date, :date
  end
end
