# == Schema Information
#
# Table name: syllabuses
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :bigint           not null
#  teacher_id :bigint           not null
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

  has_many :units
  has_many :assessments, through: :units

	accepts_nested_attributes_for :units, allow_destroy: true
end
