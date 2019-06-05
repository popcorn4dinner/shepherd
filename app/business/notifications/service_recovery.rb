# frozen_string_literal: true

module Notifications
  class ServiceRecovery
    include SlackNotifiable

    delegate :channel_name, :webhook_url, to: :@team

    def initialize(team, trigger, _target, _details)
      @team = team
      @trigger = trigger
    end

    protected

    def slack_message
      {
        title: "Service has recovered",
        attachments: [
          {
            text: "`#{@trigger.name}` has recovered and is operating normally.",
            color: 'good',
            value: "Current status is #{@trigger.status}"
          }
        ]
      }
    end
  end
end
