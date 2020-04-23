# frozen_string_literal: true

require 'entities/purchase'
require 'entities/product'
require 'services/application_service'

module Services
  module Purchases
    class UpdatePurchaseProduct < ApplicationService
      include Import[
        'contracts.purchases.update_purchase_product_contract',
        'repos.purchase_repo'
      ]

      option :product, Dry::Types().Instance(Entities::Product)
      option :purchase, Dry::Types().Instance(Entities::Purchase)

      def call
        validation_result = validate

        if validation_result.success?
          purchase_repo.update(purchase.id, validation_result.to_h)
        else
          validation_result
        end
      end

      private

      def unvalidated_params
        { product_id: product.id }
      end

      def validate
        update_purchase_product_contract.call(unvalidated_params)
      end
    end
  end
end
