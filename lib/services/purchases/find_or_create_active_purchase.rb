# frozen_string_literal: true

require 'services/application_service'

module Services
  module Purchases
    # Find or create active purchase in database
    class FindOrCreateActivePurchase < ApplicationService
      include Import['repos.purchase_repo']

      def call
        purchase = purchase_repo.active
        return purchase if purchase

        purchase_repo.create(state: 'active')
      end
    end
  end
end
