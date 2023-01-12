class AddSectionedToInstruments < ActiveRecord::Migration[7.0]
  def change
    add_column :instruments, :sectioned, :boolean, default: false
  end
end
