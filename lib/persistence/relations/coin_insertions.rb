# frozen_string_literal: true

module Persistence
  module Relations
    # CoinInsertions database interface
    class CoinInsertions < ROM::Relation[:sql]
      schema(:coin_insertions, infer: true) do
        associations do
          belongs_to :coin
        end
      end

      auto_struct(true)
    end
  end
end
