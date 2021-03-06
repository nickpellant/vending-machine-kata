# frozen_string_literal: true

require 'entities'

module Repos
  class ApplicationRepo < ROM::Repository::Root
    struct_namespace(Entities)

    def self.new
      super(App['database'])
    end
  end
end
