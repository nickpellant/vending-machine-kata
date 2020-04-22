# frozen_string_literal: true

require 'dry/system/stubs'

App.enable_stubs!

RSpec.configure do |config|
  config.after do
    App.unstub
  end
end
