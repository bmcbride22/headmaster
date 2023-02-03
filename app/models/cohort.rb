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
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, class_name: 'StudentProfile', foreign_key: 'student_id'

	validates :name, presence: true
	validates :name, uniqueness: { scope: %i[start_date end_date] }


  def student_names_f_last
    students.map do |student|
      student.first_name[0] + '.' + student.last_name
    end
  end

  def student_roster_table_headers
    [{ text: 'Name', value: 'student_name' },
     { text: 'Student ID', value: 'student_id' },
     { text: 'Account Registered', value: 'registered', sortable: true },
     { text: 'Parent Account', value: 'parent_attached', sortable: true },
     { text: 'Email', value: 'email' },
     { text: 'Courses', value: 'course_history' }]
  end

  def student_roster_table_items
    students.map do |student|
      {
        student_name: student.full_name,
        student_id: student.id,
        registered: student.registered,
        parent_attached: student.parent_attached,
        email: student.email,
        course_history: student.course_history
      }
    end
  end
end
