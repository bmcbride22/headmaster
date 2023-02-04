# == Schema Information
#
# Table name: semester_courses
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :bigint           not null
#  semester_id :bigint           not null
#
# Indexes
#
#  index_semester_courses_on_course_id    (course_id)
#  index_semester_courses_on_semester_id  (semester_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (semester_id => semesters.id)
#
require "test_helper"

class SemesterCourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
