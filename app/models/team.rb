# frozen_string_literal: true

# Teams are owners of projects.
class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]

  validates :name, presence: true
  validate :channel_has_correct_format
  validates_format_of :webhook_url, with: URI.regexp(%w[http https]), allow_blank: true

  private

  def channel_has_correct_format
    unless channel_name.blank? || channel_name.start_with?('#')
      errors.add(:channel_name, 'Wrong websitehas to start with #')
    end
  end
end
