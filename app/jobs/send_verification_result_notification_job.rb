# frozen_string_literal: true

class SendVerificationResultNotificationJob < ApplicationJob
  queue_as :default

  def perform(service_name, results)
    target_service = Service.find_by name: result.target_name

    notification = Notifications::ServiceVerification.new(
      trigger_service_name: service_name,
      service_name: target_service.name,
      team: target_service.team,
      results: results
    )

    notification.push
  end
end
