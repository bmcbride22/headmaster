class RemoveStartEndDateFromCohorts < ActiveRecord::Migration[7.0]
  def change
    remove_column :cohorts, :start_date, :date
    remove_column :cohorts, :end_date, :date
  end
end
