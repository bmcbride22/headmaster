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
  belongs_to :student, class_name: 'User', optional: true
  has_many :grades
  has_many :enrollments, dependent: :destroy, foreign_key: 'student_id'
  has_many :cohorts, through: :enrollments
  # These wont work, I need to create methods to access them
  has_many :courses, through: :cohorts
  has_many :syllabuses, through: :courses

  def name
    "#{first_name} #{last_name}"
  end

  def courselist
    courselist = []
    courses.each do |course|
      courselist.push(course.name)
    end
    courselist
  end
end
