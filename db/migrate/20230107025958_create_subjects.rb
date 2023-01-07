class CreateSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.references :discipline, foreign_key: { to_table: :subjects }

      t.timestamps
    end
  end
end
