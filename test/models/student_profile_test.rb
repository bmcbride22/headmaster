# == Schema Information
#
# Table name: student_profiles
#
#  id         :bigint           not null, primary key
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :bigint
#
# Indexes
#
#  index_student_profiles_on_student_id  (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (student_id => users.id)
#
require "test_helper"

class StudentProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
