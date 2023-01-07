# == Schema Information
#
# Table name: instruments
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
#  index_instruments_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#
class Instrument < ApplicationRecord
  belongs_to :subject
  has_many :assessments
  has_many :units, through: :assessments
end
