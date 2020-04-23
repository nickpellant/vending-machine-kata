# frozen_string_literal: true

module Persistence
  module Relations
    # Coins database interface
    class Coins < ROM::Relation[:sql]
      schema(:coins, infer: true) do
        associations do
          has_many :coin_insertions
        end
      end

      auto_struct(true)
    end
  end
end
