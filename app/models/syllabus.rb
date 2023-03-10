# == Schema Information
#
# Table name: syllabuses
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  subject_id  :bigint           not null
#  teacher_id  :bigint           not null
#
# Indexes
#
#  index_syllabuses_on_subject_id  (subject_id)
#  index_syllabuses_on_teacher_id  (teacher_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (teacher_id => users.id)
#
class Syllabus < ApplicationRecord
  belongs_to :teacher, class_name: 'User'
  has_many :courses
  belongs_to :subject

  has_many :units, dependent: :destroy
  has_many :assessments, through: :units

  accepts_nested_attributes_for :units, allow_destroy: true

  validates :title, presence: true
  validates :teacher, presence: true

  def main_units
    units.select(&:main_unit?)
  end

  def sections
    sections = []
    main_units.each do |main_unit|
      sections << main_unit.sections
    end
    sections.flatten
  end

  def cohort_grades(cohort)
    cohort_grades = []
    main_units.each do |main_unit|
      cohort_grades << main_unit.cohort_grades(cohort)
    end
    cohort_grades
  end

  def student_grades(student)
    student_grades = []
    main_units.each do |main_unit|
      student_grades << main_unit.student_grades(student)
    end
    student_grades
  end
end
