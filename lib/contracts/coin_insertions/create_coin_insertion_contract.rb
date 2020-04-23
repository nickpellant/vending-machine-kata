# frozen_string_literal: true

require_relative '../application_contract'

module Contracts
  module CoinInsertions
    # Contract to validate coin insertion data prior to entity creation
    class CreateCoinInsertionContract < ApplicationContract
      schema do
        required(:coin_id).filled(:integer)
      end
    end
  end
end
