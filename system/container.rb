# frozen_string_literal: true

require 'dry/system/container'

# Recognise callable objects with dependency injection
class CallableLoader < Dry::System::Loader
  def call(*args)
    constant.respond_to?(:call) ? constant : constant.new(*args)
  end
end

# Application dependency container
class App < Dry::System::Container
  configure do |config|
    config.auto_register = 'lib'
    config.loader = CallableLoader
  end

  load_paths!('lib')
end

App.start(:dotenv)
App.start(:logger)
App.start(:database)
