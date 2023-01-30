# == Schema Information
#
# Table name: grades
#
#  id            :bigint           not null, primary key
#  date          :date
#  marks         :integer
#  score         :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assessment_id :bigint           not null
#  course_id     :bigint           not null
#  student_id    :bigint           not null
#
# Indexes
#
#  index_grades_on_assessment_id  (assessment_id)
#  index_grades_on_course_id      (course_id)
#  index_grades_on_student_id     (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (assessment_id => assessments.id)
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (student_id => student_profiles.id)
#
class Grade < ApplicationRecord
  before_save :create_section_average

  belongs_to :assessment
  has_one :unit, through: :assessment
  has_one :parent_unit, through: :unit

  belongs_to :course
  belongs_to :student, class_name: 'StudentProfile'

  private

  # write a callback function to create a new unit average for the grades student when a new grade gets created,
  # and set the previously current average to false for that student / unit pairing.

  def create_section_average
    if Average.where(student:, unit:, course:).empty?
      Average.create(student:, unit:, course:, average: score, date: date || Date.new, current: true)
    else
      previous_average = Average.find_by(student:, unit:, course:, current: true)
      unit_average_numerator = 0
      unit_average_denominator = 0
      puts unit
      puts unit.grades
      unit.grades.where(student:).each do |grade|
        puts grade.student
        puts student
        if grade.student == student

          unit_average_numerator += (grade.score * grade.assessment.weight)
          unit_average_denominator += grade.assessment.weight
        else
          next
        end
      end

      unit_average = unit_average_numerator / unit_average_denominator

      new_average = Average.new(student:, unit:, course:, average: unit_average, date: date || Date.new, current: true)
      previous_average.update!(current: false) if new_average.save! && previous_average
    end
  end
end
