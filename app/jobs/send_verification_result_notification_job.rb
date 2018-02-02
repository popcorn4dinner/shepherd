# frozen_string_literal: true

class SendVerificationResultNotificationJob < ApplicationJob
  queue_as :default

  def perform(service_name, target_name, result_data)
    results = result_data.map { |data_set| Verification::Result.from_h data_set }

    target_service = Service.find_by name: target_name

    Notifications::ServiceVerification.new(target_service.team, service_name, target_name, results)
                                      .push
  end
end
