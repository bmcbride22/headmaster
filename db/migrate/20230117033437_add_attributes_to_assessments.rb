class AddAttributesToAssessments < ActiveRecord::Migration[7.0]
  def change
    add_column :assessments, :title, :string
    add_column :assessments, :assessment_type, :string
    add_reference :assessments, :subject, null: false, foreign_key: true
  end
end
