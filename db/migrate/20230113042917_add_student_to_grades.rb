class AddStudentToGrades < ActiveRecord::Migration[7.0]
  def change
    add_reference :grades, :student, null: false, foreign_key: { to_table: :student_profiles }
  end
end
