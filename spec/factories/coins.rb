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

  f.trait(:ten_pence) do |t|
    t.denomination { '10p' }
  end

  f.trait(:twenty_pence) do |t|
    t.denomination { '20p' }
  end

  f.trait(:processing) do |t|
    t.state { 'processing' }
  end

  f.trait(:dispensed) do |t|
    t.state { 'dispensed' }
  end

  f.trait(:processed) do |t|
    t.state { 'processed' }
  end
end
