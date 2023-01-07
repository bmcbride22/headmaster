# == Schema Information
#
# Table name: units
#
#  id          :bigint           not null, primary key
#  name        :string
#  weight      :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  syllabus_id :bigint           not null
#
# Indexes
#
#  index_units_on_syllabus_id  (syllabus_id)
#
# Foreign Keys
#
#  fk_rails_...  (syllabus_id => syllabuses.id)
#
class Unit < ApplicationRecord
  belongs_to :syllabus
  has_many :unit_assessments
  has_many :assessments, through: :unit_assessments
end
