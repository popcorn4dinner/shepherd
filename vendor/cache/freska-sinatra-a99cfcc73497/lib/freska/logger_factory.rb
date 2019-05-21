require 'logger'

module Freska
  class LoggerFactory
    class << self
      
      def create_for(settings)
        Logger.new(
          target_for(settings.framework.logger.target),
          level: level_for(settings.framework.logger.level)
        )
      end

      private

      def level_for(level_setting)
        case level_setting
        when 'fatal'
          Logger::FATAL
        when 'error'
          Logger::ERROR
        when 'warn'
          Logger::WARN
        when 'info'
          Logger::INFO
        when 'debug'
          Logger::DEBUG
        end
      end

      def target_for(target_setting)
        case target_setting
        when 'stdout'
          STDOUT
        when 'stderr'
          STDERR
        else
          target_setting
        end
      end
    end
  end
end
