# frozen_string_literal: true

require 'commands/application_command'
require 'entities/product'

module Commands
  class StockProduct < ApplicationCommand
    include Import[
      'logger',
      'repos.product_repo',
      'services.products.create_product',
      'services.products.update_product_stock'
    ]

    option :name, Dry::Types['strict.string']
    option :price, Dry::Types['strict.decimal']
    option :quantity_to_stock, Dry::Types['strict.integer']

    def call
      @product = find_product

      if product
        update_product_stock
      else
        create_product
      end
    end

    private

    attr_reader :product

    def find_product
      product_repo.by_params(name: name, price: price)
    end

    def update_product_stock
      result = super.call(product: product, quantity_to_stock: quantity_to_stock)

      case result
      when Entities::Product
        log_product_stock_updated(result.quantity_in_stock)
      when Dry::Validation::Result
        log_product_stock_update_failed_validation
      end
    end

    def log_product_stock_updated(new_quantity_in_stock)
      logger.info(
        "'#{name}' stock changed from #{product.quantity_in_stock} to #{new_quantity_in_stock}"
      )
    end

    def log_product_stock_update_failed_validation
      logger.error("Attempting to update stock for '#{name}' led to a validation error")
    end

    def create_product
      result = super.call(name: name, price: price, quantity_in_stock: quantity_to_stock)

      case result
      when Entities::Product
        log_product_created
      when Dry::Validation::Result
        log_product_creation_failed_validation
      end
    end

    def log_product_created
      logger.info("#{quantity_to_stock} of '#{name}' stocked at #{price.to_f}/unit")
    end

    def log_product_creation_failed_validation
      logger.error("Attempting to create '#{name}' led to a validation error")
    end
  end
end
