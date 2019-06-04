# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(team, trigger, target, notification_class, details = nil)
    notification_class.new(team, trigger, target, details).push
  end
end
