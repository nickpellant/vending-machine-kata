# frozen_string_literal: true

require_relative '../application_service'

module Services
  module Products
    # Validate product data and persist product to database
    class CreateProduct < ApplicationService
      include Import[
        'contracts.products.create_product_contract',
        'repos.product_repo',
      ]

      option :name, Dry::Types['strict.string']
      option :price, Dry::Types['strict.decimal']
      option :quantity_in_stock, Dry::Types['strict.integer']

      def call
        validation_result = validate

        if validation_result.success?
          product_repo.create(validation_result.to_h)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { name: name, price: price, quantity_in_stock: quantity_in_stock }
      end

      def validate
        create_product_contract.call(unvalidated_params)
      end
    end
  end
end
