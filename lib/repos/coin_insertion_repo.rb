# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  # Convenience interface for coin insertion relations
  class CoinInsertionRepo < ApplicationRepo[:coin_insertions]
    commands(:create)

    def count_by_coin(coin)
      coin_insertions.where(coin_id: coin.id).count
    end
  end
end
