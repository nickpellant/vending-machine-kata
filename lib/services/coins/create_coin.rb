# frozen_string_literal: true

require 'services/application_service'
require 'entities/coin'

module Services
  module Coins
    class CreateCoin < ApplicationService
      include Import[
        'contracts.coins.create_coin_contract',
        'repos.coin_repo',
      ]

      option :denomination, Dry::Types['strict.string']

      def call
        validation_result = validate

        if validation_result.success?
          coin_repo.create(validation_result.to_h)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { denomination: denomination, state: 'processing' }
      end

      def validate
        create_coin_contract.call(unvalidated_params)
      end
    end
  end
end
