class RemoveDateFromAssessments < ActiveRecord::Migration[7.0]
  def change
    remove_column :assessments, :date, :date
  end
end
