# frozen_string_literal: true

require 'entities/coin'
require 'services/application_service'

module Services
  module Coins
    # Validate changed data and updates the quantity of the coin in the machine
    class UpdateCoinQuantityInMachine < ApplicationService
      include Import[
        'contracts.coins.update_coin_quantity_in_machine_contract',
        'repos.coin_repo',
      ]

      option :coin, Dry::Types().Instance(Entities::Coin)
      option :quantity_to_load, Dry::Types['strict.integer']

      def call
        validation_result = validate

        if validation_result.success?
          coin_repo.update(coin.id, validation_result.to_h)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { quantity_in_machine: coin.quantity_in_machine + quantity_to_load }
      end

      def validate
        update_coin_quantity_in_machine_contract.call(unvalidated_params)
      end
    end
  end
end
