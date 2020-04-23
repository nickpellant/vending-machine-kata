# frozen_string_literal: true

module Persistence
  module Relations
    # Coins database interface
    class Coins < ROM::Relation[:sql]
      schema(:coins, infer: true)

      auto_struct(true)
    end
  end
end
