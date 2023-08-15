class User < ApplicationRecord
  include SoftDeleter
  has_many :books, dependent: :destroy
end
