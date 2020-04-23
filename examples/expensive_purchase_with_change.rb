require_relative '../run'

App['commands.stock_product'].call(name: 'Macbook Pro', price: 3000.to_d, quantity_to_stock: 10)
App['commands.load_coin'].call(denomination: '£1', quantity_to_load: 500)
App['commands.load_coin'].call(denomination: '£2', quantity_to_load: 500)
App['commands.load_coin'].call(denomination: '50p', quantity_to_load: 1000)

2001.times do
  App['commands.insert_coin'].call(denomination: '£1')
end

501.times do
  App['commands.insert_coin'].call(denomination: '£2')
end

App['commands.select_product'].call(product_name: 'Macbook Pro')
App['commands.confirm_purchase'].call
