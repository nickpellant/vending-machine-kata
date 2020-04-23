# frozen_string_literal: true

require 'services/application_service'
require 'entities/coin'

module Services
  module Coins
    class CreateCoins < ApplicationService
      include Import[
        'contracts.coins.create_coin_contract',
        'repos.coin_repo',
      ]

      option :denomination, Dry::Types['strict.string']
      option :coin_state, Dry::Types['strict.string'], default: proc { 'processed' }
      option :quantity_to_load, Dry::Types['strict.integer']

      def call
        validation_result = validate

        if validation_result.success?
          validated_params = quantity_to_load.times.map { validation_result.to_h }
          coin_repo.create(validated_params)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { denomination: denomination, state: coin_state }
      end

      def validate
        create_coin_contract.call(unvalidated_params)
      end
    end
  end
end
