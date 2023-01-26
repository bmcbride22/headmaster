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
  has_many :grades, foreign_key: 'student_id'
  has_many :enrollments, dependent: :destroy, foreign_key: 'student_id'
  has_many :cohorts, through: :enrollments
  has_many :courses, through: :cohorts
  has_many :syllabuses, through: :courses

  def full_name
    "#{first_name} #{last_name}"
  end

  def course_history
    courselist = []
    courses.each do |course|
      courselist.push(course.title)
    end
    courselist
  end

  def registered
    !student.nil?
  end

  def parent_attached
    if registered
      !student.parent.nil?
    else
      false
    end
  end

  def email
    if registered
      student.email
    else
      'N/A'
    end
  end
end
