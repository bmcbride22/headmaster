class Course < ApplicationRecord
  belongs_to :cohort
  belongs_to :syllabus
end
