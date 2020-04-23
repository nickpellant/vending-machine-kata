# frozen_string_literal: true

require 'commands/application_command'
require 'entities/coin'

module Commands
  module VendingMachine
    # Loads a coin in the vending machine
    class LoadCoin < ApplicationCommand
      include Import[
        'logger',
        'repos.coin_repo',
        'services.coins.update_coin_quantity_in_machine'
      ]

      option :denomination, Dry::Types['strict.string']
      option :quantity_to_load, Dry::Types['strict.integer']

      def call
        @coin = find_coin

        if coin
          update_coin_quantity_in_machine
        else
          log_coin_not_found
        end
      end

      private

      attr_reader :coin

      def find_coin
        coin_repo.by_denomination(denomination)
      end

      def update_coin_quantity_in_machine
        result = super.call(coin: coin, quantity_to_load: quantity_to_load)

        case result
        when Entities::Coin
          log_coin_quantity_in_machine_updated(result.quantity_in_machine)
        when Dry::Validation::Result
          log_coin_updating_quantity_in_machine_failed_validation
        end
      end

      def log_coin_quantity_in_machine_updated(new_quantity_in_machine)
        logger.info(
          "'#{denomination}' quantity in machine changed from #{coin.quantity_in_machine} to "\
          "#{new_quantity_in_machine}"
        )
      end

      def log_coin_updating_quantity_in_machine_failed_validation
        logger.error("Attempting to load '#{denomination}' coins led to a validation error")
      end

      def log_coin_not_found
        logger.error("'#{denomination}' coin not found")
      end
    end
  end
end
