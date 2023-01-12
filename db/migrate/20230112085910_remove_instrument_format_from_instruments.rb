class RemoveInstrumentFormatFromInstruments < ActiveRecord::Migration[7.0]
  def change
    remove_column :instruments, :instrument_format, :string
  end
end
