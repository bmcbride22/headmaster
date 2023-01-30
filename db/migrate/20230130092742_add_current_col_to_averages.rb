class AddCurrentColToAverages < ActiveRecord::Migration[7.0]
  def change
    add_column :averages, :current, :boolean, default: true
  end
end
