# == Schema Information
#
# Table name: courses
#
#  id          :bigint           not null, primary key
#  description :text
#  end_date    :date
#  start_date  :date
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cohort_id   :bigint           not null
#  syllabus_id :bigint           not null
#
# Indexes
#
#  index_courses_on_cohort_id    (cohort_id)
#  index_courses_on_syllabus_id  (syllabus_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (syllabus_id => syllabuses.id)
#
class Course < ApplicationRecord
  belongs_to :cohort
  belongs_to :syllabus

  has_one :teacher, through: :syllabus
  has_many :students, through: :cohort
  has_many :units, through: :syllabus
  has_many :assessments, through: :units
  has_many :grades, through: :assessments

  def course_grades_table_headers
    headers = [{ text: 'Student', value: 'student_full_name', fixed: true, width: 150 }]
    syllabus.main_units.each do |main_unit|
      main_unit.sections.each do |section|
        section.assessments.each do |assessment|
          headers << { text: assessment.title, value: assessment.table_value_label, sortable: true }
        end
        headers << { text: section.title, value: section.table_value_label, sortable: true }
      end
      headers << { text: main_unit.title, value: main_unit.table_value_label, sortable: true }
    end
    headers
  end

  def sections
    units.reject(&:main_unit?)
  end

  def course_student_grades_table_item(student)
    items = {}
    syllabus.main_units.each do |main_unit|
      main_unit.sections.each do |section|
        section.assessments.each do |assessment|
          items = items.merge({ assessment.table_value_label.to_sym => assessment.student_grade(student)&.score || 0 })
        end
        items = items.merge({ section.table_value_label.to_sym => section.unit_total_score(student).round(2) })
      end
      items = items.merge({ main_unit.table_value_label.to_sym => main_unit.unit_total_score(student).round(2) })
    end
    items
  end

  def course_cohort_grades_table_items(cohort)
    cohort.students.map do |student|
      { student_full_name: student.full_name }.merge(course_student_grades_table_item(student))
    end
  end
end
