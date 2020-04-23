# frozen_string_literal: true

module Persistence
  module Relations
    class Coins < ROM::Relation[:sql]
      schema(:coins, infer: true)

      auto_struct(true)
    end
  end
end
