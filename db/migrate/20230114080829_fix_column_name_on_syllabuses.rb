class FixColumnNameOnSyllabuses < ActiveRecord::Migration[7.0]
  def change
    rename_column :syllabuses, :name, :title
  end
end
