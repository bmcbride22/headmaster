# == Schema Information
#
# Table name: courses
#
#  id          :bigint           not null, primary key
#  end_date    :date
#  start_date  :date
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
require "test_helper"

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
