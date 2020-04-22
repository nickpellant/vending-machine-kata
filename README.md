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
