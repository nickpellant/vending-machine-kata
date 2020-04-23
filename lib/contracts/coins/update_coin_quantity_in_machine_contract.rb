# frozen_string_literal: true

require 'contracts/application_contract'

module Contracts
  module Coins
    # Contract to validate coin data for updating the quantity of the coin in the machine
    class UpdateCoinQuantityInMachineContract < ApplicationContract
      schema do
        required(:quantity_in_machine).filled(:integer)
      end

      rule(:quantity_in_machine) do
        key.failure('must be greater than or equal to zero') if value.negative?
      end
    end
  end
end
