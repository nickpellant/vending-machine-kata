# frozen_string_literal: true

require 'entities/product'
require 'services/application_service'

module Services
  module Coins
    class DispenseChange < ApplicationService
      include Import[
        'logger',
        'repos.coin_repo',
        'services.coins.transition_coins_to_state'
      ]

      option :coins_total_value, Dry::Types['strict.decimal']
      option :product_price, Dry::Types['strict.decimal']

      def call
        transition_processing_coins_to_processed

        return log_no_change_to_dispense unless change_value_to_dispense.positive?

        @change = []

        grouped_dispensable_coins.each do |dispensable_coin_group|
          fill_change_to_max(dispensable_coin_group)
        end

        transition_change_to_dispensed

        log_change_dispensed
      end

      private

      attr_accessor :change

      def change_value_to_dispense
        coins_total_value - product_price
      end

      def change_value_dispensed
        change.map(&:value).sum
      end

      def change_value_remaining_to_dispense
        change_value_to_dispense - change_value_dispensed
      end

      def grouped_dispensable_coins
        @grouped_dispensable_coins ||= begin
          dispensable_coins = coin_repo.dispensable
          dispensable_coins.group_by(&:denomination)
        end
      end

      def fill_change_to_max(dispensable_coin_group)
        dispensable_coin_group.last.each do |coin|
          break if coin.value > change_value_remaining_to_dispense

          change << coin
        end
      end

      def transition_change_to_dispensed
        transition_coins_to_state.call(coins: change, state: 'dispensed')
      end

      def transition_processing_coins_to_processed
        processing_coins = coin_repo.processing
        transition_coins_to_state.call(coins: processing_coins, state: 'processed')
      end

      def log_change_dispensed
        logger.info(
          "#{change_value_dispensed.to_f} of owed #{change_value_to_dispense.to_f} change "\
          "dispensed [#{change.map(&:denomination).join(', ')}]"
        )
      end

      def log_no_change_to_dispense
        logger.info('No change to dispense')
      end
    end
  end
end
