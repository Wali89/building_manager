class AddIndexesToTables < ActiveRecord::Migration[6.1]
  def change
    # Indexes for the buildings table
    add_index :buildings, :client_id, if_not_exists: true
    add_index :buildings, [:client_id, :address], unique: true, if_not_exists: true

    # Indexes for the clients table
    add_index :clients, :name, unique: true, if_not_exists: true

    # Indexes for the custom_fields table
    add_index :custom_fields, :client_id, if_not_exists: true
    add_index :custom_fields, [:client_id, :name], unique: true, if_not_exists: true

    # Indexes for the custom_field_values table
    add_index :custom_field_values, :building_id, if_not_exists: true
    add_index :custom_field_values, :custom_field_id, if_not_exists: true
    add_index :custom_field_values, [:building_id, :custom_field_id], unique: true, if_not_exists: true
  end
end