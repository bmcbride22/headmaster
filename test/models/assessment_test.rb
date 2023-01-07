# == Schema Information
#
# Table name: assessments
#
#  id         :bigint           not null, primary key
#  date       :date
#  title      :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :bigint           not null
#
# Indexes
#
#  index_assessments_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#
require "test_helper"

class AssessmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
