# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  class ProductRepo < ApplicationRepo[:products]
    commands(:create, update: :by_pk)

    def all
      products.to_a
    end

    def by_name(name)
      products.where(name: name).one
    end

    def by_params(params)
      products.where(params).one
    end

    def count
      products.count
    end

    def exists?(params)
      products.exist?(params)
    end
  end
end
