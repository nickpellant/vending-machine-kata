# frozen_string_literal: true

require 'commands/application_command'
require 'entities/coin'

module Commands
  # Loads a coin in the vending machine
  class LoadCoin < ApplicationCommand
    include Import[
      'logger',
      'repos.coin_repo',
      'services.coin_insertions.create_coin_insertions'
    ]

    option :denomination, Dry::Types['strict.string']
    option :quantity_to_load, Dry::Types['strict.integer'].constrained(gt: 0)

    def call
      @coin = find_coin

      if coin
        create_coin_insertions
      else
        log_coin_not_found
      end
    end

    private

    attr_reader :coin

    def find_coin
      coin_repo.by_denomination(denomination)
    end

    def create_coin_insertions
      result = super.call(coin: coin, quantity_to_load: quantity_to_load)

      case result
      when Entities::CoinInsertion
        log_coins_loaded
      when Dry::Validation::Result
        log_coins_rejected
      end
    end

    def log_coins_loaded
      logger.info("#{quantity_to_load} #{denomination} coins loaded")
    end

    def log_coins_rejected
      logger.error('Coins rejected')
    end

    def log_coin_not_found
      logger.error("#{denomination} coin is not accepted")
    end
  end
end
