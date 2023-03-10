# == Schema Information
#
# Table name: instrument_sections
#
#  id            :bigint           not null, primary key
#  title         :string           not null
#  total_marks   :integer
#  weight        :float            default(1.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  instrument_id :bigint           not null
#
# Indexes
#
#  index_instrument_sections_on_instrument_id  (instrument_id)
#
# Foreign Keys
#
#  fk_rails_...  (instrument_id => instruments.id)
#
require "test_helper"

class InstrumentSectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
