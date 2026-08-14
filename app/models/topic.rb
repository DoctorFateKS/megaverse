class Topic < ApplicationRecord
  belongs_to :story, optional: true
  has_many :mentions, dependent: :destroy

  validates :guid, presence: true, uniqueness: true
end
