# frozen_string_literal: true

require 'entities'

Factory = ROM::Factory.configure do |config|
  config.rom = App['database']
end.struct_namespace(Entities)

factories_paths = Pathname.new(Dir.pwd).join('spec/factories/*.rb')
Dir[factories_paths].sort.each { |f| require f }
