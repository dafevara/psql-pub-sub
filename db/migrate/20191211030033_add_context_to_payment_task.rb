class AddContextToPaymentTask < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_tasks, :context, :jsonb
  end
end
