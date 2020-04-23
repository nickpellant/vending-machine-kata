# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  class CoinRepo < ApplicationRepo[:coins]
    commands(:create, update: :by_pk)

    def count_by_denomination(denomination)
      coins.where(denomination: denomination).count
    end

    def count_processed
      coins.where(state: 'processed').count
    end

    def count_dispensed
      coins.where(state: 'dispensed').count
    end

    def dispensable
      coins.where { state.not('dispensed') }.to_a
    end

    def processing
      coins.where(state: 'processing').to_a
    end
  end
end
