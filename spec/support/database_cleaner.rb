# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    connection = App['database'].gateways[:default].connection

    DatabaseCleaner[:sequel, connection: connection].strategy = :transaction
    DatabaseCleaner[:sequel, connection: connection].clean_with(:truncation)
  end

  config.around do |example|
    connection = App['database'].gateways[:default].connection

    DatabaseCleaner[:sequel, connection: connection].cleaning do
      example.run
    end
  end
end
