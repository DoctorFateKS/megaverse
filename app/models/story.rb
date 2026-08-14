class Story < ApplicationRecord
  has_many :topics, dependent: :nullify

  validates :slug, presence: true, uniqueness: true
end
