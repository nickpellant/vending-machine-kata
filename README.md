# vending-machine-kata

![ci](https://github.com/nickpellant/vending-machine-kata/workflows/ci/badge.svg)

## Installation

This project uses PostgreSQL as its data store. You will need to create databases manually with `psql`.

```
$ psql postgres
postgres=# CREATE DATABASE vending_machine_kata_development;
postgres=# CREATE DATABASE vending_machine_kata_test;
```

Database URLs are configured in `.env.development` and `.env.test`.

Run `rake db:seeds` to add acceptable coin denominations to database.

## Usage

Interact with the vending machine via commands in `lib/commands/vending_machine`. An example sequence might be:

```ruby
App['commands.vending_machine.stock_product'].call(name: 'Coca-cola', price: 0.5.to_d, quantity_to_stock: 10)
App['commands.vending_machine.load_coin'].call(denomination: '10p', quantity_to_load: 10)

App['commands.vending_machine.insert_coin'].call(denomination: '20p')
App['commands.vending_machine.insert_coin'].call(denomination: '20p')
App['commands.vending_machine.insert_coin'].call(denomination: '10p')

App['commands.vending_machine.select_product'].call(product_name: 'Coca-cola')
```
