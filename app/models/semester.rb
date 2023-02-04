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
class Semester < ApplicationRecord
  before_save :set_current_semester

  has_many :semester_courses
  has_many :courses, through: :semester_courses

  has_many :semester_cohorts
  has_many :cohorts, through: :semester_cohorts

  private

  def set_current_semester
    Semester.where.not(id:).update_all(current: false) if current
  end
end
