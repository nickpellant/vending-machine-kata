# frozen_string_literal: true

require 'entities/product'
require 'services/application_service'

module Services
  module Products
    class DispenseProduct < ApplicationService
      include Import[
        'logger',
        'services.products.update_product_stock'
      ]

      option :product, Dry::Types().Instance(Entities::Product)

      def call
        result = update_product_stock.call(product: product, quantity_to_stock: -1)

        case result
        when Entities::Product
          log_product_dispensed
        when Dry::Validation::Result
          raise 'Product failed to dispense'
        end

        result
      end

      private

      def log_product_dispensed
        logger.info("#{product.name} product dispensed")
      end
    end
  end
end
