# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :coins do
      primary_key :id
      column :denomination, String, null: false, index: true
      column :quantity_in_machine, Integer, null: false, default: 0
      column :value, BigDecimal, null: false, size: [20, 10]
    end
  end
end
