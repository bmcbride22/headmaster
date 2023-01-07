class AddRoleAndChildToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 1
    add_reference :users, :parent, foreign_key: { to_table: :users }
  end
end
