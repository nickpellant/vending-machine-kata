# frozen_string_literal: true

require 'rom/sql/rake_task'

namespace :db do
  task setup: :environment do
    ROM::SQL::RakeSupport.env = App['database']
  end
end
