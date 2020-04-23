# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  class PurchaseRepo < ApplicationRepo[:purchases]
    commands(:create, update: :by_pk)

    def count
      purchases.count
    end

    def active
      purchases.where(state: 'active').one
    end
  end
end
