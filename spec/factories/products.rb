# frozen_string_literal: true

Factory.define(:product) do |f|
  f.name { fake(:commerce, :product_name) }
  f.price { fake(:commerce, :price).to_d }
  f.quantity_in_stock { fake(:number, :within, range: 1..10) }
end
