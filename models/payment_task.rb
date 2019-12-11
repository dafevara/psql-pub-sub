require_relative 'user'
require_relative 'payment'
require_relative 'product'

class PaymentTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment

  class << self
    def enqueue!(args)
      PaymentTask.create!(
        user_id: args[:user_id],
        payment_id: args[:payment_id],
        context: {
          comments: args[:comments],
          prime: [true, false].sample
        }
      )
    end

    def next
      query = <<-SQL
        UPDATE #{table_name} SET
          processing = true,
          tries_left = tries_left - 1,
          error = NULL,
          next_try_at = NULL,
          updated_at = CURRENT_TIMESTAMP
        WHERE id = (
          SELECT id
          FROM #{table_name}
          WHERE tries_left > 0
          AND (
            next_try_at IS NULL OR
            next_try_at < CURRENT_TIMESTAMP
          )
          AND (
            processing = false OR
            updated_at < CURRENT_TIMESTAMP - INTERVAL '10 SECOND'
          )
          ORDER BY priority ASC, next_try_at ASC, id ASC
          FOR UPDATE SKIP LOCKED
          LIMIT 1
        )
        RETURNING *
      SQL
      find_by_sql(query).first
    end
  end


  def perform!
    p 'performing'
    debit = payment.product.price
    balance = user.balance
    balance -= debit

    if balance < 0
      message = <<~ERROR
        User doesn't have enought credits.
        context: #{context['comments']}.
        product price: #{debit},
        current balance: #{user.balance}
      ERROR

      if tries_left > 0
        update!(
          error: message,
          tries_left: tries_left - 1,
          next_try_at: Time.now + 10
        )
      end
    end

    user.balance = balance

    unless user.save
      if tries_left > 0
        update!(
          error: "Unable to update user balance",
          tries_left: tries_left - 1,
          next_try_at: Time.now + 10
        )
      end
    end
  end
end
