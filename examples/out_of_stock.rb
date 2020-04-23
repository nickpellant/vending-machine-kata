# frozen_string_literal: true

require_relative '../run'

App['commands.stock_product'].call(name: 'Sprite', price: 0.5.to_d, quantity_to_stock: 1)

App['commands.insert_coin'].call(denomination: '20p')
App['commands.insert_coin'].call(denomination: '20p')
App['commands.insert_coin'].call(denomination: '10p')

App['commands.select_product'].call(product_name: 'Sprite')
App['commands.confirm_purchase'].call

App['commands.select_product'].call(product_name: 'Sprite')
App['commands.confirm_purchase'].call
