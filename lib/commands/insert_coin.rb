# frozen_string_literal: true

require 'commands/application_command'
require 'entities/coin'

module Commands
  class InsertCoin < ApplicationCommand
    option :denomination, Dry::Types['strict.string']

    include Import[
      'logger',
      'repos.coin_repo',
      'services.coins.create_coin'
    ]

    def call
      result = create_coin

      case result
      when Entities::Coin
        log_coin_accepted
      when Dry::Validation::Result
        log_coin_not_accepted
      end
    end

    private

    def find_coin
      coin_repo.by_denomination(denomination)
    end

    def create_coin
      super.call(denomination: denomination)
    end

    def log_coin_accepted
      logger.info('Coin accepted')
    end

    def log_coin_not_accepted
      logger.error('Coin is not accepted')
    end
  end
end
