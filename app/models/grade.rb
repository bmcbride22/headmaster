# == Schema Information
#
# Table name: grades
#
#  id            :bigint           not null, primary key
#  marks         :integer
#  score         :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assessment_id :bigint           not null
#  student_id    :bigint           not null
#
# Indexes
#
#  index_grades_on_assessment_id  (assessment_id)
#  index_grades_on_student_id     (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (assessment_id => assessments.id)
#  fk_rails_...  (student_id => student_profiles.id)
#
class Grade < ApplicationRecord
  belongs_to :assessment
  belongs_to :student, class_name: 'StudentProfile'
end
