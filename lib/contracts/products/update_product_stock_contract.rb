# frozen_string_literal: true

require_relative '../application_contract'

module Contracts
  module Products
    # Contract to validate product data for updating an existing products stock
    class UpdateProductStockContract < ApplicationContract
      schema do
        required(:quantity_in_stock).filled(:integer)
      end

      rule(:quantity_in_stock) do
        key.failure('must be greater than or equal to zero') if value.negative?
      end
    end
  end
end
