# == Schema Information
#
# Table name: assessments
#
#  id              :bigint           not null, primary key
#  assessment_type :string
#  date            :date
#  description     :text
#  title           :string
#  weight          :float            default(1.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  subject_id      :bigint           not null
#  teacher_id      :bigint           not null
#  unit_id         :bigint           not null
#
# Indexes
#
#  index_assessments_on_subject_id  (subject_id)
#  index_assessments_on_teacher_id  (teacher_id)
#  index_assessments_on_unit_id     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (teacher_id => users.id)
#  fk_rails_...  (unit_id => units.id)
#
class Assessment < ApplicationRecord
  belongs_to :teacher, class_name: 'User'
  belongs_to :unit
  belongs_to :subject
  has_many :grades, dependent: :destroy

  def syllabus
    unit.syllabus
  end

  def courses
    unit.syllabus.courses
  end

  def cohort_grades(cohort)
    grades.where(student_id: cohort.students)
  end

  def student_grade(student)
    grades.find_by(student:)
  end
end
