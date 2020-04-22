# frozen_string_literal: true

App.boot(:dotenv) do
  init do
    require 'dotenv'

    ENV['APP_ENV'] ||= 'development'

    Dotenv.load(".env.#{ENV['APP_ENV']}")
  end
end
