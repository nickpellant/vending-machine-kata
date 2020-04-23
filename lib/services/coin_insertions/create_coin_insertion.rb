# frozen_string_literal: true

require 'services/application_service'
require 'entities/coin'

module Services
  module CoinInsertions
    # Persist coin insertion to database
    class CreateCoinInsertion < ApplicationService
      include Import[
        'contracts.coin_insertions.create_coin_insertion_contract',
        'repos.coin_insertion_repo',
      ]

      option :coin, Dry::Types().Instance(Entities::Coin)

      def call
        validation_result = validate

        if validation_result.success?
          coin_insertion_repo.create(validation_result.to_h)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { coin_id: coin.id }
      end

      def validate
        create_coin_insertion_contract.call(unvalidated_params)
      end
    end
  end
end
