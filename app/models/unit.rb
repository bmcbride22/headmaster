# == Schema Information
#
# Table name: units
#
#  id             :bigint           not null, primary key
#  main_unit      :boolean          default(TRUE), not null
#  title          :string
#  weight         :float            default(1.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_unit_id :bigint
#  syllabus_id    :bigint
#
# Indexes
#
#  index_units_on_parent_unit_id  (parent_unit_id)
#  index_units_on_syllabus_id     (syllabus_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_unit_id => units.id)
#  fk_rails_...  (syllabus_id => syllabuses.id)
#
class Unit < ApplicationRecord
  belongs_to :syllabus, -> { where(main_unit: true) }
  belongs_to :parent_unit, -> { where(main_unit: false) }, class_name: 'Unit', optional: true

  has_many :assessments
  has_many :instruments, through: :assessments

  has_many :sections, class_name: 'Unit', foreign_key: 'parent_unit_id'
end
