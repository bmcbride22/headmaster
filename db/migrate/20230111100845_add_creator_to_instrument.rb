class AddCreatorToInstrument < ActiveRecord::Migration[7.0]
  def change
    add_reference :instruments, :creator, null: false, foreign_key: { to_table: :users }
  end
end
