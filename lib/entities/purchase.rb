# frozen_string_literal: true

require_relative 'application_entity'

module Entities
  class Purchase < ApplicationEntity
    def complete?
      state == 'complete'
    end

    def product?
      !product_id.nil?
    end
  end
end
