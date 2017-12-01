class RunnerParam < ApplicationRecord

  belongs_to :verifier
  validates :name, :value, presence: true


end
