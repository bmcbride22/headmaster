class RemoveStudentsFromGrades < ActiveRecord::Migration[7.0]
  def change
    remove_reference :grades, :student, null: false, foreign_key: { to_table: :users }
  end
end
