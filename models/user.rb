class User < ActiveRecord::Base
  has_many :payments
end
