# frozen_string_literal: true

Factory.define(:coin) do |f|
  f.denomination '1p'
  f.state 'processing'

  f.trait(:one_pence) do |t|
    t.denomination { '1p' }
  end

  f.trait(:two_pence) do |t|
    t.denomination { '2p' }
  end

  f.trait(:processing) do |t|
    t.state { 'processing' }
  end

  f.trait(:returned) do |t|
    t.state { 'returned' }
  end

  f.trait(:received) do |t|
    t.state { 'received' }
  end
end
