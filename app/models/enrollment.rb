# == Schema Information
#
# Table name: enrollments
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cohort_id  :bigint           not null
#  student_id :bigint           not null
#
# Indexes
#
#  index_enrollments_on_cohort_id   (cohort_id)
#  index_enrollments_on_student_id  (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (student_id => student_profiles.id)
#
class Enrollment < ApplicationRecord
  belongs_to :student, class_name: 'StudentProfile'
  belongs_to :cohort

  validates :student, presence: true
  validates :cohort, presence: true
  validates :student, uniqueness: { scope: :cohort }
end
