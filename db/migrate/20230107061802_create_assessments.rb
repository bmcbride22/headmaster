class CreateAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :assessments do |t|
      t.date :date
      t.string :title
      t.references :subject, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
