# frozen_string_literal: true

class SendVerificationResultNotificationJob < ApplicationJob
  queue_as :default

  def perform(service_name, team, notification_class)


    Notifications::ServiceVerification.new(target_service.team, service_name, target_name, results)
                                      .push
  end
end
