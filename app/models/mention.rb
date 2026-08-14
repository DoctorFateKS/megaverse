class Mention < ApplicationRecord
  belongs_to :topic

  validates :character_name, presence: true, uniqueness: { scope: :topic_id }
end
