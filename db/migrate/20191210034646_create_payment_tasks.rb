class CreatePaymentTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_tasks do |t|
      t.integer   :user_id
      t.integer   :payment_id

      t.timestamp :created_at, null: false, default: -> { 'current_timestamp' }
      t.timestamp :updated_at, null: false, default: -> { 'current_timestamp' }

      t.integer   :tries_left, null: false, default: 5
      t.timestamp :next_try_at
      t.integer   :priority,   null: false, default: 0
      t.string    :error
      t.boolean   :processing, null: false, default: false
    end
  end
end
