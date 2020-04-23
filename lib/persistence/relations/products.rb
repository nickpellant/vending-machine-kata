# frozen_string_literal: true

module Persistence
  module Relations
    class Products < ROM::Relation[:sql]
      schema(:products, infer: true) do
        associations do
          has_many :purchases
        end
      end

      auto_struct(true)
    end
  end
end
