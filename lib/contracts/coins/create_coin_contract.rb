# frozen_string_literal: true

require 'contracts/application_contract'
require 'entities/coin'

module Contracts
  module Coins
    class CreateCoinContract < ApplicationContract
      schema do
        required(:denomination).filled(:string).value(included_in?: Entities::Coin::DENOMINATIONS)
        required(:state).filled(:string).value(included_in?: Entities::Coin::STATES)
      end
    end
  end
end
