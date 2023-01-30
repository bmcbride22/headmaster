# == Schema Information
#
# Table name: averages
#
#  id         :bigint           not null, primary key
#  average    :float
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#  student_id :bigint           not null
#  unit_id    :bigint           not null
#
# Indexes
#
#  index_averages_on_course_id   (course_id)
#  index_averages_on_student_id  (student_id)
#  index_averages_on_unit_id     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (student_id => student_profiles.id)
#  fk_rails_...  (unit_id => units.id)
#
require "test_helper"

class AverageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
