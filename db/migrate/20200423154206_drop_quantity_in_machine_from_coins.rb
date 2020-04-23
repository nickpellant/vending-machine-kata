# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :coins do
      drop_column :quantity_in_machine
    end
  end

  down do
    alter_table :coins do
      add_column :quantity_in_machine, Integer, null: false, default: 0
    end
  end
end
