class AddStartEndDateToCohorts < ActiveRecord::Migration[7.0]
  def change
    add_column :cohorts, :start_date, :date
    add_column :cohorts, :end_date, :date
  end
end
