class AddReferenceToUnits < ActiveRecord::Migration[7.0]
  def change
    add_reference :units, :parent_unit, foreign_key: { to_table: :units }
  end
end
