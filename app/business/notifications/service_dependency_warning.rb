# frozen_string_literal: true

module Notifications
  class ServiceDependencyWarning
    include SlackNotifiable

    delegate :channel_name, :webhook_url, to: :@team

    def initialize(team, trigger, target, _details)
      @team = team
      @trigger = trigger
      @target = target
    end

    protected

    def slack_message
      {
        title: 'Failing dependency',
        attachments: [
          {
            text: "*Warning:* Verify state of `#{@target.name}`! \n *#{@trigger.name}*, a dependency of *#{@target.name}* is not working correctly.\n This might impact this apps functionality",
            color: 'warning',
            value: "Current status is #{@trigger.status}",
            mrkdwn_in: ["text"]
          }
        ]
      }
    end
  end
end
