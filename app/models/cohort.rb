# == Schema Information
#
# Table name: cohorts
#
#  id          :bigint           not null, primary key
#  description :text
#  end_date    :date
#  name        :string
#  start_date  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cohort < ApplicationRecord
  has_many :courses
  has_many :enrollments
  has_many :students, through: :enrollments, class_name: 'StudentProfile', foreign_key: 'student_id'

  def student_names_f_last
    students.map do |student|
      student.first_name[0] + '.' + student.last_name
    end
  end
end
