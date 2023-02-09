class AddLinksAndGradeToAverage < ActiveRecord::Migration[7.0]
  def change
    add_reference :averages, :previous_average, foreign_key: { to_table: :averages }
    add_reference :averages, :next_average, foreign_key: { to_table: :averages }
    add_reference :averages, :grade, null: false, foreign_key: true
  end
end
