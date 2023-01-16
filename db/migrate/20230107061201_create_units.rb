class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :title
      t.references :syllabus, null: false, foreign_key: true
      t.float :weight, default: 1, null: false, max: 1, min: 0

      t.timestamps
    end
  end
end
