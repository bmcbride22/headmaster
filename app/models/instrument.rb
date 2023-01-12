# == Schema Information
#
# Table name: instruments
#
#  id          :bigint           not null, primary key
#  description :text
#  sectioned   :boolean          default(FALSE)
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :bigint           not null
#  subject_id  :bigint           not null
#
# Indexes
#
#  index_instruments_on_creator_id  (creator_id)
#  index_instruments_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (subject_id => subjects.id)
#
class Instrument < ApplicationRecord
  belongs_to :subject
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  has_many :assessments
  has_many :units, through: :assessments
  has_many :instrument_sections, dependent: :destroy
end
