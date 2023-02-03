# == Schema Information
#
# Table name: averages
#
#  id          :bigint           not null, primary key
#  average     :float
#  course_avg  :boolean          default(FALSE)
#  current     :boolean          default(TRUE)
#  date        :date
#  section_avg :boolean          default(FALSE)
#  unit_avg    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :bigint           not null
#  student_id  :bigint           not null
#  unit_id     :bigint
#
# Indexes
#
#  index_averages_on_course_id   (course_id)
#  index_averages_on_student_id  (student_id)
#  index_averages_on_unit_id     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (student_id => student_profiles.id)
#  fk_rails_...  (unit_id => units.id)
#
class Average < ApplicationRecord
  belongs_to :student, class_name: 'StudentProfile'
  belongs_to :course
  belongs_to :unit, optional: true

  validates :student, presence: true
  validates :course, presence: true
  validates :average, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :date, presence: true
  validates :unit, presence: true, unless: :course_avg
  validates :unit, absence: true, if: :course_avg
  validates :current, uniqueness: { scope: %i[student unit course] }, if: :current

  # create a custom validation to ensure that only one average is current for a student, unit, course combination
end
