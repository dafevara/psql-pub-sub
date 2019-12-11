require_relative 'payment_task'

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  after_create :enqueue_event!

  def enqueue_event!
    PaymentTask.enqueue!(
      user_id: self.user.id,
      payment_id: self.id,
      comments: Faker::Lorem.paragraph(sentence_count: 2)
    )
  end

end
