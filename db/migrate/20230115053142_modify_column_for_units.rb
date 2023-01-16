class ModifyColumnForUnits < ActiveRecord::Migration[7.0]
  def change
    change_column_null :units, :syllabus_id, true
    add_column :units, :main_unit, :boolean, default: true, null: false
  end
end
