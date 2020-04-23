# frozen_string_literal: true

require 'commands/application_command'
require 'entities/purchase'

module Commands
  module VendingMachine
    # Select a product from the vending machine to purchase
    class SelectProduct < ApplicationCommand
      include Import[
        'logger',
        'repos.product_repo',
        'services.purchases.find_or_create_active_purchase',
        'services.purchases.update_purchase_product'
      ]
      option :product_name, Dry::Types['strict.string']

      def call
        @product = find_product

        if product
          @purchase = find_or_create_active_purchase
          update_purchase_product
        else
          log_product_not_found
        end
      end

      private

      attr_reader :product, :purchase

      def find_product
        product_repo.by_name(product_name)
      end

      def find_or_create_active_purchase
        super.call
      end

      def update_purchase_product
        result = super.call(product: product, purchase: purchase)

        case result
        when Entities::Purchase
          log_product_selected
        end
      end

      def log_product_selected
        logger.info('Product selected for purchase')
      end

      def log_product_not_found
        logger.error('Product not found')
      end
    end
  end
end
