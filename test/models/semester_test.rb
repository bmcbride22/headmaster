# == Schema Information
#
# Table name: semesters
#
#  id         :bigint           not null, primary key
#  current    :boolean          default(FALSE)
#  end_date   :date
#  start_date :date
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class SemesterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
