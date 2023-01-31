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
    previous_average = Average.find_by(student:, section_avg: true, unit:, course:, current: true)
    if previous_average.nil?
      Average.create(student:, unit:, course:, average: score, section_avg: true, date: date || Date.new,
                     current: true)
    else
      section_average_numerator = 0
      section_average_denominator = 0

      unit.grades.where(student:).each do |grade|
        if grade.student == student
          section_average_numerator += (grade.score * grade.assessment.weight)
          section_average_denominator += grade.assessment.weight
        else
          next
        end
      end

      section_average = section_average_numerator / section_average_denominator

      new_average = Average.new(student:, unit:, section_avg: true, course:, average: section_average,
                                date: date || Date.new, current: true)
      previous_average.update!(current: false) if new_average.save! && previous_average

    end
    create_unit_average
  end

  def create_unit_average
    previous_average = Average.find_by(student:, unit: unit.parent_unit, unit_avg: true, course:, current: true)
    if previous_average.nil?
      Average.create(student:, unit: unit.parent_unit, course:, average: score, unit_avg: true, date: date || Date.new,
                     current: true)
    else
      unit_average_numerator = 0
      unit_average_denominator = 0

      unit.parent_unit.sections.each do |section|
        section_avg = Average.includes(:unit).find_by(student:, unit: section, section_avg: true, course:,
                                                      current: true)
        next if section_avg.nil?

        unit_average_numerator += (section_avg.average * section.weight)
        unit_average_denominator += section.weight
      end
      unit_average = unit_average_numerator / unit_average_denominator
      new_average = Average.new(student:, unit: unit.parent_unit, course:, unit_avg: true, average: unit_average, date: date || Date.new,
                                current: true)
      previous_average.update!(current: false) if new_average.save! && previous_average
    end
    create_course_average
  end

  def create_course_average
    previous_average = Average.find_by(student:, course_avg: true, course:, current: true)
    puts previous_average

    if previous_average.nil?
      puts ' prev = nil'
      puts student
      puts course
      puts score

      Average.create!(student:, course:, average: score, course_avg: true, date: date || Date.new, current: true)
      puts 'Created new course average', Average.last.course_avg?
    else
      puts ' NOOOOOOOOOOTTTTTT NIIIIILLLLL'
      course_average_numerator = 0
      course_average_denominator = 0
      course.main_units.each do |unit|
        puts unit
        unit_avg = Average.find_by(student:, course:, unit:, unit_avg: true, current: true)
        next if unit_avg.nil?

        puts unit_avg.average
        puts unit.weight
        course_average_numerator += (unit_avg.average * unit.weight)
        puts course_average_numerator
        course_average_denominator += unit.weight
      end
      course_average = course_average_numerator / course_average_denominator
      new_average = Average.new(student:, course:, course_avg: true, average: course_average, date: date || Date.new,
                                current: true)
      previous_average.update!(current: false) if new_average.save! && previous_average
    end
  end
end
