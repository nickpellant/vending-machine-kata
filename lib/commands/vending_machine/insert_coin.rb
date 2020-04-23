# frozen_string_literal: true

require 'commands/application_command'
require 'entities/coin'

module Commands
  module VendingMachine
    # Insert a coin in the vending machine to contribute toward a purchase
    class InsertCoin < ApplicationCommand
      option :denomination, Dry::Types['strict.string']

      include Import[
        'logger',
        'repos.coin_repo',
        'services.coin_insertions.create_coin_insertion'
      ]

      def call
        @coin = find_coin

        if coin
          create_coin_insertion
        else
          log_coin_not_accepted
        end
      end

      private

      attr_reader :coin

      def find_coin
        coin_repo.by_denomination(denomination)
      end

      def create_coin_insertion
        result = super.call(coin: coin)

        case result
        when Entities::CoinInsertion
          log_coin_accepted
        end
      end

      def log_coin_accepted
        logger.info('Coin accepted')
      end

      def log_coin_not_accepted
        logger.error('Coin is not accepted')
      end
    end
  end
end
