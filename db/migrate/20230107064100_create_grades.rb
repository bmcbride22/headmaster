class CreateGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :grades do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.float :score

      t.timestamps
    end
  end
end
