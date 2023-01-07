class RemoveTypeFromInstruments < ActiveRecord::Migration[7.0]
  def change
    remove_column :instruments, :type, :string
  end
end
