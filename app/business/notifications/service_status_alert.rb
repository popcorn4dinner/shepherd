# frozen_string_literal: true

module Notifications
  class ServiceStatusAlert
    include SlackNotifiable

    delegate :channel_name, :webhook_url, to: :@team

    def initialize(team, service_name, old_status, new_status, details)
      @team = team
      @old_status = old_status
      @new_status = new_status
      @service_name = service_name
      @details = details
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
      "System tests for #{@service_name}"
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
