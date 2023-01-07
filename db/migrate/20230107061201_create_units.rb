class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :name
      t.references :syllabus, null: false, foreign_key: true
      t.float :weight

      t.timestamps
    end
  end
end
