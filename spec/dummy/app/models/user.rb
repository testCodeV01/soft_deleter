class User < ApplicationRecord
  include SoftDeleter
  has_many :books, dependent: :destroy

  validates :name, presence: true
end
