# frozen_string_literal: true

Factory.define(:purchase) do |f|
  f.product_id { 0 }
  f.state { 'active' }

  f.trait(:active) do |t|
    t.state { 'active' }
  end

  f.trait(:cancelled) do |t|
    t.state { 'cancelled' }
  end
end
