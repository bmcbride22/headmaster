class CreateSemesterCohorts < ActiveRecord::Migration[7.0]
  def change
    create_table :semester_cohorts do |t|
      t.references :cohort, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end
  end
end
