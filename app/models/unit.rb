# == Schema Information
#
# Table name: units
#
#  id             :bigint           not null, primary key
#  main_unit      :boolean          default(TRUE), not null
#  title          :string
#  weight         :float            default(1.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_unit_id :bigint
#  syllabus_id    :bigint
#
# Indexes
#
#  index_units_on_parent_unit_id  (parent_unit_id)
#  index_units_on_syllabus_id     (syllabus_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_unit_id => units.id)
#  fk_rails_...  (syllabus_id => syllabuses.id)
#
class Unit < ApplicationRecord
  belongs_to :syllabus
  belongs_to :parent_unit, class_name: 'Unit', optional: true
  has_many :sections, class_name: 'Unit', foreign_key: 'parent_unit_id', dependent: :destroy

  has_many :assessments, dependent: :destroy
  has_many :grades, through: :assessments
  has_many :averages

  def cohort_grades(cohort)
    cohort_grades = []
    if main_unit?
      sections.each do |section|
        section_cohort_grades = []
        section.assessments.each do |assessment|
          section_cohort_grades << assessment.cohort_grades(cohort)
        end
        cohort_grades << section_cohort_grades
      end
    else
      assessments.each do |assessment|
        cohort_grades << assessment.cohort_grades(cohort)
      end
    end
    cohort_grades
  end

  def student_grades(student)
    student_grades = []
    assessments.each do |assessment|
      student_grades << assessment.student_grade(student)
    end
    student_grades
  end

  def unit_total_score(student); end
end
