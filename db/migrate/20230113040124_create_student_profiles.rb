class CreateStudentProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :student_profiles do |t|
      t.references :student, foreign_key: { to_table: :users }
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
