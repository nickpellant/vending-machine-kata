# frozen_string_literal: true

require 'entities/product'
require 'services/application_service'

module Services
  module Products
    class UpdateProductStock < ApplicationService
      include Import[
        'contracts.products.update_product_stock_contract',
        'repos.product_repo',
      ]

      option :product, Dry::Types().Instance(Entities::Product)
      option :quantity_to_stock, Dry::Types['strict.integer']

      def call
        validation_result = validate

        if validation_result.success?
          product_repo.update(product.id, validation_result.to_h)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { quantity_in_stock: product.quantity_in_stock + quantity_to_stock }
      end

      def validate
        update_product_stock_contract.call(unvalidated_params)
      end
    end
  end
end
