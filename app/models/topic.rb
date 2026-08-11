class Topic < ApplicationRecord
  validates :guid, presence: true, uniqueness: true
end
