# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default(1)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  parent_id              :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_parent_id             (parent_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => users.id)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :children, class_name: 'User', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'User', optional: true

	has_one :student_profile
  has_many :enrollments, through: :student_profile
  has_many :cohorts, through: :enrollments
  has_many :courses, through: :cohorts

  has_many :instruments, foreign_key: 'creator_id'
  has_many :syllabuses, foreign_key: 'teacher_id'
  has_many :grades

  has_many :messages
  has_many :participants
  has_many :chatrooms, through: :participants

  has_person_name
end
