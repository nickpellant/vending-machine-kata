# frozen_string_literal: true

Factory.define(:coin_insertion) do |f|
  f.coin_id { 0 }
  f.state { 'processing' }

  f.trait(:processing) do |t|
    t.state { 'processing' }
  end

  f.trait(:returned) do |t|
    t.state { 'returned' }
  end

  f.trait(:recieved) do |t|
    t.state { 'recieved' }
  end
end
