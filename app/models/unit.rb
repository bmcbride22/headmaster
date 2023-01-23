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
  belongs_to :parent_unit, -> { where(main_unit: false) }, class_name: 'Unit', optional: true

  has_many :assessments, dependent: :destroy

  has_many :sections, class_name: 'Unit', foreign_key: 'parent_unit_id', dependent: :destroy

  def unit_assessments
    if main_unit?
      ass_arr = []
      sections.each do |section|
        section_assessments = []
        section.assessments.each do |assessment|
          section_assessments << assessment
        end
        ass_arr << section_assessments
      end
      ass_arr
    else
      assessments
    end
  end

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

  def unit_total_score(student)
    total_score = 0
    if main_unit?
      sections.each do |section|
        total_score += section.unit_total_score(student) * section.weight
      end
    else
      assessments.each do |assessment|
        total_score += (assessment.student_grade(student)&.score&.* assessment.weight) || 0
      end
    end
    total_score
  end

  def table_value_label
    if main_unit?
      "unit_#{id}_total_grade"
    else
      "section_#{id}_total_grade"
    end
  end
end
