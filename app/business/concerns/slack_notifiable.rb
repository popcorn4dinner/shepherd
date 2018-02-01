# frozen_string_literal: true

require 'active_support/concern'
require 'slack-notifier'

module SlackNotifiable
  extend ActiveSupport::Concern

  def push
    return unless can_be_notified?

    Slack::Notifier.new(webhook_url, username: Rails.config.notifications.slack_user_name)
                   .send(slack_notifier_method, slack_message)
  end

  protected

  def slack_message
    inspect
  end

  private

  def can_be_notified?
    respond_to?(:webhook_url) && webhook_url.present?
  end

  def channel
    uses_specific_channel? ? channel_name : Rails.config.notifications.default_slack_channel
  end

  def uses_specific_channel?
    respond_to?(:channel_name) && channel_name.present?
  end

  def slack_notifier_method
    slack_message.is_a? String ? :ping : :post
  end
end
