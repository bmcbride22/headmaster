# == Schema Information
#
# Table name: cohorts
#
#  id         :bigint           not null, primary key
#  end_date   :date
#  name       :string
#  start_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Cohort < ApplicationRecord
  has_many :courses
  has_many :enrollments
  has_many :users, through: :enrollments
end
