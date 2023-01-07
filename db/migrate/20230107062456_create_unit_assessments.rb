class CreateUnitAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :unit_assessments do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.float :unit_weight

      t.timestamps
    end
  end
end
