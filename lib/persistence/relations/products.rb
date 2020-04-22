# frozen_string_literal: true

module Persistence
  module Relations
    # Products database interface
    class Products < ROM::Relation[:sql]
      schema(:products, infer: true)

      auto_struct(true)
    end
  end
end
