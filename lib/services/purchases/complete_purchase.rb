# frozen_string_literal: true

require 'entities/purchase'
require 'services/application_service'

module Services
  module Purchases
    class CompletePurchase < ApplicationService
      include Import['repos.purchase_repo']

      option :purchase, Dry::Types().Instance(Entities::Purchase)

      def call
        purchase_repo.update(purchase.id, state: 'complete')
      end
    end
  end
end
