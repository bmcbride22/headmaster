# == Schema Information
#
# Table name: semester_cohorts
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cohort_id   :bigint           not null
#  semester_id :bigint           not null
#
# Indexes
#
#  index_semester_cohorts_on_cohort_id    (cohort_id)
#  index_semester_cohorts_on_semester_id  (semester_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (semester_id => semesters.id)
#
class SemesterCohort < ApplicationRecord
    belongs_to :cohort
    belongs_to :semester
            
end
