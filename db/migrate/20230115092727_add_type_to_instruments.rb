class AddTypeToInstruments < ActiveRecord::Migration[7.0]
  def change
    add_column :instruments, :type, :string
  end
end
