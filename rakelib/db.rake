# frozen_string_literal: true

require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    ENV['DATABASE_MIGRATION'] ||= 'true'

    require_relative '../run'

    ROM::SQL::RakeSupport.env = App['database']
  end

  desc 'Seed database'
  task seed: :environment do
    require Pathname.new(Dir.pwd).join('db/seeds.rb')
  end
end
