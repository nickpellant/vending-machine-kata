# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  # Convenience interface for coin relations
  class CoinRepo < ApplicationRepo[:coins]
    commands(:create, update: :by_pk)

    def all
      coins.to_a
    end

    def by_denomination(denomination)
      coins.where(denomination: denomination).one
    end

    def count
      coins.count
    end

    def exists?(params)
      coins.exist?(params)
    end
  end
end
