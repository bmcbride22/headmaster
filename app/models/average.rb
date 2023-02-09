# == Schema Information
#
# Table name: averages
#
#  id                  :bigint           not null, primary key
#  average             :float
#  course_avg          :boolean          default(FALSE)
#  current             :boolean          default(TRUE)
#  date                :date
#  section_avg         :boolean          default(FALSE)
#  unit_avg            :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  course_id           :bigint           not null
#  grade_id            :bigint           not null
#  previous_average_id :bigint
#  student_id          :bigint           not null
#  unit_id             :bigint
#
# Indexes
#
#  index_averages_on_course_id            (course_id)
#  index_averages_on_grade_id             (grade_id)
#  index_averages_on_previous_average_id  (previous_average_id)
#  index_averages_on_student_id           (student_id)
#  index_averages_on_unit_id              (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (grade_id => grades.id)
#  fk_rails_...  (previous_average_id => averages.id)
#  fk_rails_...  (student_id => student_profiles.id)
#  fk_rails_...  (unit_id => units.id)
#
class Average < ApplicationRecord
  belongs_to :student, class_name: 'StudentProfile'
  belongs_to :course
  belongs_to :unit, optional: true
  belongs_to :grade
  belongs_to :previous_average, class_name: 'Average', optional: true

  has_one :next_average, class_name: 'Average', foreign_key: 'previous_average_id', dependent: :destroy

  validates :student, presence: true
  validates :course, presence: true
  validates :average, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :date, presence: true
  validates :unit, presence: true, unless: :course_avg
  validates :unit, absence: true, if: :course_avg

  # create a custom validation to ensure that only one average is current for a student, unit, course combination
end
