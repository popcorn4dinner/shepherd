class ExternalResource < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  validates :name, presence: true
  has_and_belongs_to_many :services

end
