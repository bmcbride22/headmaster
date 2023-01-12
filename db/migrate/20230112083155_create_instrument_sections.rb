class CreateInstrumentSections < ActiveRecord::Migration[7.0]
  def change
    create_table :instrument_sections do |t|
      t.string :title, null: false
      t.float :weight, default: 1
      t.integer :total_marks
      t.references :instrument, null: false, foreign_key: true

      t.timestamps
    end
  end
end
