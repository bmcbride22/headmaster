class CreateSyllabuses < ActiveRecord::Migration[7.0]
  def change
    create_table :syllabuses do |t|
      t.string :name
      t.references :teacher, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
