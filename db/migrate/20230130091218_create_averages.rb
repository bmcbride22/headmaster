class CreateAverages < ActiveRecord::Migration[7.0]
  def change
    create_table :averages do |t|
      t.float :average
      t.references :student, null: false, foreign_key: { to_table: :student_profiles }
      t.references :course, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
