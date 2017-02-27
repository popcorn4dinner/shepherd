class Service < ApplicationRecord
  validates :name, presence: true
  validates :project, presence: true

  belongs_to :project
  has_many :internal_dependencies, :through => :friendships
  has_and_belongs_to_many :external_resources
end
