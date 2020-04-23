# frozen_string_literal: true

require 'contracts/application_contract'
require 'entities/coin_insertion'

module Contracts
  module CoinInsertions
    # Contract to validate coin insertion data prior to entity creation
    class CreateCoinInsertionContract < ApplicationContract
      schema do
        required(:coin_id).filled(:integer)
        required(:state).filled(:string).value(included_in?: Entities::CoinInsertion::STATES)
      end
    end
  end
end
