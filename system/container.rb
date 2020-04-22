# frozen_string_literal: true

require 'dry/system/container'

# Application dependency container
class App < Dry::System::Container
  configure do |config|
    config.auto_register = 'lib'
  end

  load_paths!('lib')
end
