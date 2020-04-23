# frozen_string_literal: true

relations = App['database'].relations

coins = relations.coins
permitted_coins = [
  { denomination: '1p', value: 0.01.to_d },
  { denomination: '2p', value: 0.02.to_d },
  { denomination: '5p', value: 0.05.to_d },
  { denomination: '10p', value: 0.1.to_d },
  { denomination: '20p', value: 0.2.to_d },
  { denomination: '50p', value: 0.5.to_d },
  { denomination: '£1', value: 1.to_d },
  { denomination: '£2', value: 2.to_d }
]

coins.command(:create).call(permitted_coins)
