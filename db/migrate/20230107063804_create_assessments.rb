class CreateAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :assessments do |t|
      t.references :instrument, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.float :unit_weight

      t.timestamps
    end
  end
end
