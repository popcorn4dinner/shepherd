# frozen_string_literal: true

module Notifications
  class ServiceStatusAlert
    include SlackNotifiable

    delegate :channel_name, :webhook_url, to: :@team

    def initialize(team, service, _target, details)
      @team = team
      @service = service
      @details = details
    end

    protected

    def slack_message
      {
        text: "*Alert:* `#{@service.name}` *is not working correctly*",
        attachments: [
          {
            title: "System tests of #{@service.name} are failing.",
            text:"``` \n#{@details} \n```",
            color: 'danger',
            value: 'failing tests',
            mrkdwn_in: ["text"]
          }
        ]
      }
    end
  end
end
