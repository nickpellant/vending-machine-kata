# frozen_string_literal: true

require 'services/application_service'
require 'entities/coin'

module Services
  module Coins
    class TransitionCoinsToState < ApplicationService
      include Import['repos.coin_repo']

      option :coins, Dry::Types['strict.array'].of(Dry::Types().Instance(Entities::Coin))
      option :state, Dry::Types['strict.string']

      def call
        coin_repo.update(coins.map(&:id), state: state)
      end
    end
  end
end
