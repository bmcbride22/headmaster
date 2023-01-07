class AddDateToAssessments < ActiveRecord::Migration[7.0]
  def change
    add_column :assessments, :date, :date
  end
end
