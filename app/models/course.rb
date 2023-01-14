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
end
