require_relative '../run'

App['commands.stock_product'].call(name: 'Coca-cola', price: 0.5.to_d, quantity_to_stock: 10)
App['commands.load_coin'].call(denomination: '10p', quantity_to_load: 10)

App['commands.insert_coin'].call(denomination: '20p')
App['commands.insert_coin'].call(denomination: '20p')
App['commands.insert_coin'].call(denomination: '10p')

App['commands.select_product'].call(product_name: 'Coca-cola')
App['commands.confirm_purchase'].call
