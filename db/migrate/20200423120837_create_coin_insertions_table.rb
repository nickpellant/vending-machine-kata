# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :coin_insertions do
      primary_key :id
      column :coin_id, Integer, null: false, index: true
    end

    alter_table :coin_insertions do
      add_foreign_key [:coin_id], :coins
    end
  end
end
