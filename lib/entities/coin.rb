# frozen_string_literal: true

require_relative 'application_entity'

module Entities
  class Coin < ApplicationEntity
    DENOMINATIONS = {
      '1p' => 0.01.to_d,
      '2p' => 0.02.to_d,
      '5p' => 0.05.to_d,
      '10p' => 0.1.to_d,
      '20p' => 0.2.to_d,
      '50p' => 0.5.to_d,
      '£1' => 1.to_d,
      '£2' => 2.to_d
    }.freeze
    STATES = %w[processing dispensed processed].freeze

    def value
      @value ||= DENOMINATIONS[denomination]
    end
  end
end
