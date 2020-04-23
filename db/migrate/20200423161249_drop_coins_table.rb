# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :coin_insertions do
      drop_column :coin_id
    end

    drop_table :coins

    rename_table :coin_insertions, :coins

    alter_table :coins do
      add_column :denomination, String, null: false, index: true
    end
  end

  down do
    rename_table :coins, :coin_insertions

    create_table :coins do
      primary_key :id
      column :denomination, String, null: false, index: true
      column :value, BigDecimal, null: false, size: [20, 10]
    end

    alter_table :coin_insertions do
      drop_column :denomination

      add_column :coin_id, Integer, null: true, index: true
      add_foreign_key [:coin_id], :coins
    end
  end
end
