# frozen_string_literal: true

require_relative 'application_entity'

module Entities
  class Coin < ApplicationEntity
    DENOMINATIONS = ['1p', '2p', '5p', '10p', '20p', '50p', '£1', '£2'].freeze
    STATES = %w[processing returned received].freeze
  end
end
