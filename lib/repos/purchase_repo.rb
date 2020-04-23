# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  # Convenience interface for purchase relations
  class PurchaseRepo < ApplicationRepo[:purchases]
    commands(:create, update: :by_pk)

    def active
      purchases.where(state: 'active').one
    end
  end
end
