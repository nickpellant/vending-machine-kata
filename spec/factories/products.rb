# frozen_string_literal: true

Factory.define(:product) do |f|
  f.name { fake(:commerce, :product_name) }
  f.price { fake(:commerce, :price) }
end
