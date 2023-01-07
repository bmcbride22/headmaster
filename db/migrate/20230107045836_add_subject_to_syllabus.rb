class AddSubjectToSyllabus < ActiveRecord::Migration[7.0]
  def change
    add_reference :syllabuses, :subject, null: false, foreign_key: true
  end
end
