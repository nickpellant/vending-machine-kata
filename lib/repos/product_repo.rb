# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  # Convenience interface for product relations
  class ProductRepo < ApplicationRepo[:products]
    commands(:create)

    def all
      products.to_a
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
