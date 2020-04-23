# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  class CoinRepo < ApplicationRepo[:coins]
    commands(:create)

    def count_by_denomination(denomination)
      coins.where(denomination: denomination).count
    end
  end
end
