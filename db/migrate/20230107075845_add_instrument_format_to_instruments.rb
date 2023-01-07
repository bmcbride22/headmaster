class AddInstrumentFormatToInstruments < ActiveRecord::Migration[7.0]
  def change
    add_column :instruments, :instrument_format, :string
  end
end
