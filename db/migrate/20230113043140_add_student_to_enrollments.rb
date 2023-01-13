class AddStudentToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_reference :enrollments, :student, null: false, foreign_key: { to_table: :student_profiles }
  end
end
