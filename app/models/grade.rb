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
  after_commit :create_section_average, on: :create
  after_destroy :create_section_average, prepend: true
  after_commit :update_section_averages, on: :update

  belongs_to :assessment
  has_one :unit, through: :assessment
  has_one :parent_unit, through: :unit

  has_many :averages

  belongs_to :course
  belongs_to :student, class_name: 'StudentProfile', foreign_key: 'student_id'

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :date, presence: true
  validates :student, uniqueness: { scope: %i[assessment course] }
  validates :student, presence: true
  validates :course, presence: true
  validates :assessment, presence: true

  private

  def update_section_averages
    puts 'Updating Section averages'
    date = self.date
    average = Average.find_by(grade: self, section_avg: true)
    if date != average.date
      puts 'updating average date'
      average.update!(date:)

    end
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts "First average: #{average.inspect}"
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts '#'

    loop do
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts "Current average in loop: #{average.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      section_average_numerator = 0
      section_average_denominator = 0
      useable_grades = unit.grades.includes(:student).where(student:)
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts "Useable Grades: #{useable_grades.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'

      useable_grades.each do |grade|
        puts grade.inspect
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts '#'

        if grade.date <= date
          section_average_numerator += (grade.score * grade.assessment.weight)
          puts "Section Average Numerator: #{section_average_numerator}"
          puts '#'
          puts '#'
          puts '#'
          puts '#'

          section_average_denominator += grade.assessment.weight
          puts "Section Average Denominator: #{section_average_denominator}"
          puts '#'
          puts '#'
          puts '#'
          puts '#'
          puts '#'

        else
          next
        end
      end
      section_average = section_average_numerator / section_average_denominator
      puts average.inspect
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'

      puts "Section Average: #{average&.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'

      average.update!(average: section_average)
      puts "Updated Section Average: #{average&.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'

      average = average&.next_average
      puts "Next Section Average: #{average&.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'

      break if average.nil?
    end
    puts 'Broke on Section Average == nil'
    update_unit_averages
  end

  def update_unit_averages
    puts 'Updating unit averages'
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    date = self.date
    average = Average.find_by(grade: self, unit_avg: true)
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts "First Unit Average: #{average.inspect}"
    if date != average.date
      puts 'updating average date'
      average.update!(date:)

    end

    loop do
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts "Unit Average: #{average.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      unit_average_numerator = 0
      unit_average_denominator = 0

      unit.parent_unit.sections.each do |section|
        section_avg = Average.includes(:unit).find_by(student:, unit: section, section_avg: true, course:)

        next if section_avg.nil? || section_avg.date > average.date

        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts "Section Average Used in Unit Avg: #{average.inspect}"
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        unit_average_numerator += (section_avg.average * section.weight)
        unit_average_denominator += section.weight
      end
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts "Unit Average Numerator: #{unit_average_numerator}"
      puts "Unit Average Denominator: #{unit_average_denominator}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      unit_average = unit_average_numerator / unit_average_denominator
      average.update!(average: unit_average)

      puts "Updated Unit Average: #{average.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      average = average.next_average
      puts "Next Unit Average: #{average&.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'

      break if average.nil?
    end
    puts 'Broke on Unit Average == nil'
    update_course_averages
  end

  def update_course_averages
    puts 'Updating course averages'
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    puts '#'
    date = self.date
    average = Average.find_by(grade: self, course_avg: true)
    if date != average.date
      puts 'updating average date'
      average.update!(date:)

    end

    loop do
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts "Average: #{average.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      course_average_numerator = 0
      course_average_denominator = 0

      course.main_units.each do |unit|
        unit_avg = Average.find_by(student:, course:, unit:, unit_avg: true)
        next if unit_avg.nil? || unit_avg.date > average.date

        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts "Unit Average Used in Course Avg: #{unit_avg.inspect}"
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        puts '#'
        course_average_numerator += (unit_avg.average * unit.weight)
        course_average_denominator += unit.weight
      end
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts "Course Average Numerator: #{course_average_numerator}"
      puts "Course Average Denominator: #{course_average_denominator}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      course_average = course_average_numerator / course_average_denominator
      average.update!(average: course_average)
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts "Updated Course Average: #{average.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      average = average.next_average
      puts "Next Unit Average: #{average&.inspect}"
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'
      puts '#'

      break if average.nil?
    end
    puts 'Broke on Course Average == nil'
  end

  def create_section_average
    previous_average = Average.find_by(student:, section_avg: true, unit:, course:, current: true)
    if previous_average.nil?
      Average.create(student:, unit:, course:, average: score, section_avg: true, date: date || Date.new,
                     current: true, grade: self)
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
                                date: date || Date.new, current: true, previous_average:, grade: self)
      previous_average.update!(current: false) if new_average.save! && previous_average

    end
    create_unit_average
  end

  def create_unit_average
    previous_average = Average.find_by(student:, unit: unit.parent_unit, unit_avg: true, course:, current: true)
    if previous_average.nil?
      Average.create(student:, unit: unit.parent_unit, course:, average: score, unit_avg: true, date: date || Date.new,
                     current: true, grade: self)
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
                                current: true, previous_average:, grade: self)
      previous_average.update!(current: false) if new_average.save! && previous_average
    end
    create_course_average
  end

  def create_course_average
    previous_average = Average.find_by(student:, course_avg: true, course:, current: true)

    if previous_average.nil?

      Average.create!(student:, course:, average: score, course_avg: true, date: date || Date.new, current: true,
                      grade: self)
    else
      course_average_numerator = 0
      course_average_denominator = 0
      course.main_units.each do |unit|
        unit_avg = Average.find_by(student:, course:, unit:, unit_avg: true, current: true)
        next if unit_avg.nil?

        course_average_numerator += (unit_avg.average * unit.weight)
        course_average_denominator += unit.weight
      end
      course_average = course_average_numerator / course_average_denominator
      new_average = Average.new(student:, course:, course_avg: true, average: course_average, date: date || Date.new,
                                current: true, previous_average:, grade: self)
      previous_average.update!(current: false) if new_average.save! && previous_average
    end
  end
end
