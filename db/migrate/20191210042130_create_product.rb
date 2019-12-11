class CreateProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.integer :stock
      t.integer :discount
      t.timestamps
    end
  end
end
