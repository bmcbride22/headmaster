# == Schema Information
#
# Table name: assessments
#
#  id            :bigint           not null, primary key
#  date          :date
#  unit_weight   :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  instrument_id :bigint           not null
#  unit_id       :bigint           not null
#
# Indexes
#
#  index_assessments_on_instrument_id  (instrument_id)
#  index_assessments_on_unit_id        (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (instrument_id => instruments.id)
#  fk_rails_...  (unit_id => units.id)
#
class Assessment < ApplicationRecord
  belongs_to :instrument
  belongs_to :unit
  has_many :grades, dependent: :destroy
  delegate :syllabus, to: :unit, allow_nil: true
end
