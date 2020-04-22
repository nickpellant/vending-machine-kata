# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default, ENV.fetch('APP_ENV'))

require_relative 'system/container'
