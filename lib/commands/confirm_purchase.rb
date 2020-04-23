# frozen_string_literal: true

require 'commands/application_command'

module Commands
  class ConfirmPurchase < ApplicationCommand
    include Import[
      'logger',
      'repos.product_repo',
      'repos.coin_repo',
      'repos.purchase_repo',
      'services.coins.dispense_change',
      'services.products.dispense_product',
      'services.purchases.find_or_create_active_purchase',
      'services.purchases.complete_purchase',
    ]

    def call
      purchase_repo.transaction do
        @purchase = find_or_create_active_purchase
        return log_product_not_selected unless purchase.product?

        @coins = find_coins
        @product = find_product
        return log_insufficient_money if insufficient_money?

        complete_purchase
        dispense_product
        dispense_change
      end
    end

    private

    attr_reader :coins, :product, :purchase

    def find_or_create_active_purchase
      super.call
    end

    def log_product_not_selected
      logger.error('Product not selected to purchase')
    end

    def find_coins
      coin_repo.processing
    end

    def find_product
      product_repo.by_id(purchase.product_id)
    end

    def insufficient_money?
      coins_total_value < product.price
    end

    def coins_total_value
      @coins_total_value ||= coins.map(&:value).sum
    end

    def log_insufficient_money
      money_required = (product.price - coins_total_value).to_f

      logger.error(
        "Insufficient money inserted; £#{money_required} still required to complete purchase"
      )
    end

    def dispense_product
      super.call(product: product)
    end

    def complete_purchase
      super.call(product: product, purchase: purchase)
    end

    def dispense_change
      super.call(coins_total_value: coins_total_value, product_price: product.price)
    end
  end
end
