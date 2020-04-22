# frozen_string_literal: true

App.boot(:logger) do
  init do
    require 'logger'
  end

  start do
    logger_output =
      if ENV['APP_ENV'] == 'test'
        IO::NULL
      else
        $stdout
      end

    logger = Logger.new(logger_output)
    logger.level = Logger::INFO

    register(:logger, logger)
  end
end
