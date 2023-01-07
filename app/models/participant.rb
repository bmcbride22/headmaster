# == Schema Information
#
# Table name: participants
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chatroom_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_participants_on_chatroom_id  (chatroom_id)
#  index_participants_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chatroom_id => chatrooms.id)
#  fk_rails_...  (user_id => users.id)
#
class Participant < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user
end
