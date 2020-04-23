# frozen_string_literal: true

require_relative '../application_contract'

module Contracts
  module Products
    class CreateProductContract < ApplicationContract
      schema do
        required(:name).filled(:string)
        required(:price).filled(:decimal)
        required(:quantity_in_stock).filled(:integer)
      end

      rule(:price) do
        key.failure('must be greater than or equal to zero') if value.negative?
      end

      rule(:quantity_in_stock) do
        key.failure('must be greater than or equal to zero') if value.negative?
      end
    end
  end
end
