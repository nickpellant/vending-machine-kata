# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :coin_insertions do
      add_column :state, String, null: false, index: true
    end
  end
end
