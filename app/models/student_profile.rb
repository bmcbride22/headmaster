# == Schema Information
#
# Table name: student_profiles
#
#  id         :bigint           not null, primary key
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :bigint
#
# Indexes
#
#  index_student_profiles_on_student_id  (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (student_id => users.id)
#
class StudentProfile < ApplicationRecord
  belongs_to :student, class_name: 'User'
  has_many :grades
  has_many :enrollments
end
