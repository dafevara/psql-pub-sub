require_relative '../models/payment'
require_relative '../models/user'
require 'progress_bar'

namespace 'payments' do
  desc 'Create a lot of fake payments'
  task publish: :environment do
    #FIXME:
    # this is a heavy and slow operation. Only for testing purposes
    # DO NOT use in real scenarios. Again, DO NOT use in a real scenario.

    pbar = ProgressBar.new(10000)
    10000.times do |t|
      user = User.order("RANDOM()").first
      product = Product.order('RANDOM()').first

      dice = [Faker::Number.number(digits: 2), product.price]

      Payment.create!(
        user: user,
        product: product,
        ammount: dice.sample
      )
      pbar.increment!
    end
  end
end
