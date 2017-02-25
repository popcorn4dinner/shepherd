class Project < ApplicationRecord
  belongs_to :team

  validates :name, presence: true
  validates :team, presence: true
end
