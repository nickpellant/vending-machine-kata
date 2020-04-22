# frozen_string_literal: true

require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    ENV['DATABASE_MIGRATION'] ||= 'true'

    require_relative '../run'

    ROM::SQL::RakeSupport.env = App['database']
  end
end
