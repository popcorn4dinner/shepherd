# frozen_string_literal: true

class SendVerificationResultNotificationJob < ApplicationJob
  queue_as :default

  def perform(service_name, target_name, result_data)
    results = result_data.map { |data_set| Verification::Result.from_h data_set }
    target_service = Service.find_by name: target_name

    notification = Notifications::ServiceVerification.new(
      trigger_service_name: service_name,
      service_name: target_service.name,
      team: target_service.team,
      results: results
    )

    notification.push
  end
end
