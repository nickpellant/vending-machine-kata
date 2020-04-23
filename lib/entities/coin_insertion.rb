# frozen_string_literal: true

require_relative 'application_entity'

module Entities
  # Coin insertion entity representing coin insertion data
  class CoinInsertion < ApplicationEntity
    STATES = %w[processing returned received].freeze
  end
end
