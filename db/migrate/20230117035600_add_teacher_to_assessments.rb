class AddTeacherToAssessments < ActiveRecord::Migration[7.0]
  def change
    add_reference :assessments, :teacher, null: false, foreign_key: { to_table: :users }
  end
end
