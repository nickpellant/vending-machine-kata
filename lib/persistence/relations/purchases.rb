# frozen_string_literal: true

module Persistence
  module Relations
    # Purchases database interface
    class Purchases < ROM::Relation[:sql]
      schema(:purchases, infer: true) do
        associations do
          belongs_to :product
        end
      end

      auto_struct(true)
    end
  end
end
