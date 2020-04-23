# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :purchases do
      primary_key :id
      column :product_id, Integer, null: true, index: true
      column :state, String, null: false, index: true
    end

    alter_table :purchases do
      add_foreign_key [:product_id], :products
    end
  end
end
