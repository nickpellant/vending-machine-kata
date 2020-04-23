# frozen_string_literal: true

require 'commands/application_command'
require 'entities/coin'

module Commands
  class LoadCoin < ApplicationCommand
    include Import[
      'logger',
      'repos.coin_repo',
      'services.coins.create_coins'
    ]

    option :denomination, Dry::Types['strict.string']
    option :quantity_to_load, Dry::Types['strict.integer'].constrained(gt: 0)

    def call
      result = create_coins

      case result
      when Entities::Coin
        log_coins_loaded
      when Dry::Validation::Result
        log_coins_not_accepted
      end
    end

    private

    def find_coin
      coin_repo.by_denomination(denomination)
    end

    def create_coins
      super.call(denomination: denomination, quantity_to_load: quantity_to_load)
    end

    def log_coins_loaded
      logger.info("#{quantity_to_load} #{denomination} coins loaded")
    end

    def log_coins_not_accepted
      logger.error("#{denomination} coin is not accepted")
    end
  end
end
