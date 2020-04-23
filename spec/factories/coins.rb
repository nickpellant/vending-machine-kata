# frozen_string_literal: true

Factory.define(:coin) do |f|
  f.trait(:one_pence) do |t|
    t.denomination { '1p' }
    t.value { 0.01.to_d }
  end

  f.trait(:two_pence) do |t|
    t.denomination { '2p' }
    t.value { 0.02.to_d }
  end
end
