require 'logger'

module Onion
  class CommandHandler

    include Agreement

    attr_accessor :logger

    def execute(params = {})
      raise_error_for(params) unless exceptable?(params)

      log_attempt_for(params) if logger.present?
      result = handle(**params)
      log_success_for(params) if logger.present?

      result
    rescue ::StandardError => e
      log_failure_for(params, e) if logger.present?
      raise e
    end

    def command_params
      method(:handle).parameters.map(&:last)
    end

    def self.log_blacking_for(*fields)
      @fields_to_sanitize = fields
    end

    def self.fields_to_sanitize
      @fields_to_sanitize ||= []
    end

    protected

    def handle
      implement_this!
    end

    private

    def raise_error_for(params)
      message = "Handler #{self.class.name} expects to be executed with #{command_params}, but got #{params.keys}."

      raise CommandError, message
    end

    def exceptable?(params)
      only_expected_params_in?(params) && all_expected_params_in?(params)
    end

    def only_expected_params_in?(params)
      (command_params - params.keys).empty?
    end

    def all_expected_params_in?(params)
      (params.keys - command_params).empty?
    end

    def log_attempt_for(params)
      logger.info "attempting to execute #{self.class.name} with #{blacken(params)}"
    end

    def log_success_for(params)
      logger.info "successfully executed #{self.class.name} with #{blacken(params)}"
    end

    def log_failure_for(params, error)
      logger.info "failed executing #{self.class.name} with #{blacken(params)} resulted in #{error.class.name}"
    end

    def blacken(params)
      params = params.clone
      params.each { |k, v| params[k] = self.class.fields_to_sanitize.include?(k) ? "*****" : v }
    end
  end
end
