# frozen_string_literal: true

require 'contracts/application_contract'

module Contracts
  module Purchases
    # Contract to validate purchase data for updating the product to purchase
    class UpdatePurchaseProductContract < ApplicationContract
      schema do
        required(:product_id).filled(:integer)
      end
    end
  end
end
