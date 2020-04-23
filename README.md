# vending-machine-kata

![ci](https://github.com/nickpellant/vending-machine-kata/workflows/ci/badge.svg)

## Background

This kata explores the creation of a vending machine with the follow key requirements:

1. The machine should be capable of stocking (and restocking) products
2. The machine should be capable of loading (and reloading) coins
3. The machine should accept coins of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2
4. The machine should keep track of the products it contains
5. The machine should keep track of the coins it contains
6. The machine should return the correct product when the purchase is confirmed
7. The machine should return the correct change when the purchase is confirmed

These requirements raise some questions.

### What happens when the machine has insufficient change?

Given a product with a price of 50p, and the machine is loaded with only 20p coins, what happens when a customer enters 3 x 20p coins to purchase the product? The customer is owed change but is not able to receive change from the machine.

In the above case I decided to follow the real world examples I've experienced from vending machines, and choose to take the money but not dispense change (ouch!). The machine _will_ dispense as much change as it can up to its physical change limit though.

### What happens when a product is out of stock?

Given a product is out of stock, and you try to select that product, you will be unable to. You will receive a message in the logs letting you know it was out of stock.

### What if we want to start supporting other forms of payment?

Physical currency is dying out you say? You want to convert the machine to contact-less? Well, sorry, this machine would need a reasonable rework to support that. I deliberated implementing an adapter pattern to support interchangeable payment sources, but it seemed _way_ out of scope for this kata, so I decided a note to say I'd thought about it would be sufficient.

### What if the government bring out a new coin?

Easy! Just add the new coin to our `Entities::Coin::DENOMINATIONS` hash and you're ready to roll.

### How do we know if the person stocking products or loading coins is authorized?

There should really be a key to the vending machine, but right now it's wide open. Some form of authentication and authorization would be wise in the real world, but thankfully I trust everyone using this machine right now.

### How many products can the machine hold? What about coins?

In the real world a vending machine is not infinitely large, and so we'd have some physical space limitations. I didn't build caps in on how many products you can stock, or how many coins you can load, but we'd want this in a real implementation.

## Installation

This project uses PostgreSQL as its data store. You will need to create databases manually with `psql`.

```
$ psql postgres
postgres=# CREATE DATABASE vending_machine_kata_development;
postgres=# CREATE DATABASE vending_machine_kata_test;
```

Database URLs are configured in `.env.development` and `.env.test`.

After creating the databases, make sure to migrate them:

```
$ bundle exec rake db:migrate
$ APP_ENV=test bundle exec rake db:migrate
```

## Usage

Interact with the vending machine via commands in `lib/commands`. There are a few examples in the `examples` directory to get you started.

```ruby
bundle exec ruby examples/basic.rb
```
