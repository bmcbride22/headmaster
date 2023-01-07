class RemoveDateFromInstruments < ActiveRecord::Migration[7.0]
  def change
    remove_column :instruments, :date, :date
  end
end
