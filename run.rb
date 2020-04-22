# frozen_string_literal: true

require 'bundler/setup'

ENV['APP_ENV'] ||= 'development'
Bundler.require(:default, ENV.fetch('APP_ENV'))

require_relative 'system/container'
require_relative 'system/import'
