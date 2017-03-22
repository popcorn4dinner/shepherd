class Project < ApplicationRecord
  belongs_to :team
  has_many :services

  validates :name, presence: true
  validates :team, presence: true

  def to_s
    name
  end


end
