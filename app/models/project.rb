class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  belongs_to :team
  has_many :services

  validates :name, presence: true
  validates :team, presence: true

  def to_s
    name
  end

end
