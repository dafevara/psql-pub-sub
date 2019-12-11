class CreatePayment < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :product_id
      t.integer :user_id
      t.integer :ammount

      t.timestamps
    end
  end
end
