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
require "test_helper"

class AssessmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
