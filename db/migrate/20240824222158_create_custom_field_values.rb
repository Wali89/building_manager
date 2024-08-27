class CreateCustomFieldValues < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_field_values do |t|
      t.string :value
      t.references :building, null: false, foreign_key: true
      t.references :custom_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
