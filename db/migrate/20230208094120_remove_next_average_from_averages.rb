class RemoveNextAverageFromAverages < ActiveRecord::Migration[7.0]
  def change
    remove_reference :averages, :next_average, foreign_key: { to_table: :averages }
  end
end
