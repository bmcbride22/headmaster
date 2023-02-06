class AddTeacherToCohorts < ActiveRecord::Migration[7.0]
  def change
    add_reference :cohorts, :teacher, foreign_key: { to_table: :users }
  end
end
