# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  # Convenience interface for product relations
  class ProductRepo < ApplicationRepo[:products]
    def all
      products.to_a
    end
  end
end
