# frozen_string_literal: true

require 'services/application_service'
require 'entities/coin'

module Services
  module CoinInsertions
    # Persist many coin insertions to database
    class CreateCoinInsertions < ApplicationService
      include Import[
        'contracts.coin_insertions.create_coin_insertion_contract',
        'repos.coin_insertion_repo',
      ]

      option :coin, Dry::Types().Instance(Entities::Coin)
      option :coin_insertion_state, Dry::Types['strict.string'], default: proc { 'received' }
      option :quantity_to_load, Dry::Types['strict.integer']

      def call
        validation_result = validate

        if validation_result.success?
          validated_params = quantity_to_load.times.map { validation_result.to_h }
          coin_insertion_repo.create(validated_params)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { coin_id: coin.id, state: coin_insertion_state }
      end

      def validate
        create_coin_insertion_contract.call(unvalidated_params)
      end
    end
  end
end
