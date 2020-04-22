# frozen_string_literal: true

require 'commands/application_command'
require 'entities/product'

module Commands
  module VendingMachine
    # Stocks a product in the vending machine
    class StockProduct < ApplicationCommand
      include Import[
        'logger',
        'services.products.create_product',
      ]

      option :name, Dry::Types['strict.string']
      option :price, Dry::Types['strict.decimal']
      option :quantity_to_stock, Dry::Types['strict.integer']

      def call
        result = create_product

        case result
        when Entities::Product
          log_product_created
        when Dry::Validation::Result
          log_product_creation_failed_validation
        end
      end

      private

      def create_product
        super.call(name: name, price: price, quantity_in_stock: quantity_to_stock)
      end

      def log_product_created
        logger.info("#{quantity_to_stock} of '#{name}' stocked at #{price.to_f}/unit")
      end

      def log_product_creation_failed_validation
        logger.error("Attempting to create '#{name}' led to a validation error")
      end
    end
  end
end
