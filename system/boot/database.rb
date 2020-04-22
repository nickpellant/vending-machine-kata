# frozen_string_literal: true

App.boot(:database) do
  init do
    require 'rom'
    require 'rom-repository'
    require 'rom-sql'
  end

  start do
    rom_configuration = ROM::Configuration.new(:sql, ENV.fetch('DATABASE_URL'))

    unless ENV['DATABASE_MIGRATION'] == 'true'
      rom_configuration.auto_registration(
        File.join(Dir.pwd, '/lib/persistence'), namespace: 'Persistence'
      )
    end

    register(:database, ROM.container(rom_configuration))
  end
end
