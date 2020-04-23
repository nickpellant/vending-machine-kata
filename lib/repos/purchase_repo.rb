# frozen_string_literal: true

require_relative 'application_repo'

module Repos
  class PurchaseRepo < ApplicationRepo[:purchases]
    commands(:create, update: :by_pk)

    def by_id(id)
      purchases.by_pk(id).one
    end

    def count
      purchases.count
    end

    def active
      purchases.where(state: 'active').one
    end
  end
end
