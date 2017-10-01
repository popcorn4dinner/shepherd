class RunnerParam < ApplicationRecord

  belongs_to :verifier
  validates :name, :value, :verifier, presence: true

end
