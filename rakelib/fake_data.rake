require_relative '../models/product'
require_relative '../models/user'

namespace 'fake_data' do

  desc 'generate fake data'
  task generate: :environment do
    100.times do |t|
      Product.create(
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price.to_i,
        stock: Faker::Number.number(digits: 3),
        discount: Faker::Number.number(digits: 1)
      )
    end

    100.times do |t|
      User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email
      )
    end
  end
end
