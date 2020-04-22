# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :products do
      primary_key :id
      column :name, String, null: false, index: true
      column :quantity_in_stock, Integer, null: false, default: 0
      column :price, BigDecimal, null: false, size: [20, 10]
    end
  end
end
