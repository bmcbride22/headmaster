# == Schema Information
#
# Table name: subjects
#
#  id            :bigint           not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  discipline_id :bigint
#
# Indexes
#
#  index_subjects_on_discipline_id  (discipline_id)
#
# Foreign Keys
#
#  fk_rails_...  (discipline_id => subjects.id)
#
class Subject < ApplicationRecord
  has_many :subjects, class_name: 'Subject', foreign_key: 'discipline_id'
  belongs_to :discipline, class_name: 'Subject', optional: true
	has_many :instruments
	has_many :syllabuses
end
