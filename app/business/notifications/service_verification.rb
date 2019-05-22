# frozen_string_literal: true

module Notifications
  # Notification with results of service verification
  class ServiceVerification
    include SlackNotifiable

    delegate :channel_name, :webhook_url, to: :@team

    def initialize(team, service_name, old_status, new_status)
      @team = team
      @old_status = old_status
      @new_status = new_status
      @service_name = service_name
      @trigger_service_name = trigger_service_name
    end

    protected

    def slack_message
      {
        text: message,
        attachments: attachments
      }
    end

    private

    def message
      if @trigger_service_name == @service_name
        "Verification results for *#{@service_name}*"
      else
        "*#{@service_name}* has been tested as part of the verifiction of *#{@trigger_service_name}*"
      end
    end

    def attachments
      unless @results.empty?
        @results.map { |result| attachment_for result }
      else
        [no_verifiers_warning]
      end
    end

    def attachment_for(result)
      {
        title: result.verifier_name,
        color: color_for(result.success),
        value: message_for(result)
      }
    end

    def color_for(success)
      success ? :good : :danger
    end

    def message_for(result)
      if result.message.present?
        result.message
      elsif result.success
        'Passed successfully'
      else
        'Failed'
      end
    end

    def no_verifiers_warning
      {
        title: 'No verifiers found',
        color: :warning,
        value: 'This service doesn\'t seem to have any verifiers attached to it.'
      }
    end
  end
end
