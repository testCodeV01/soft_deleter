class Book < ApplicationRecord
  include SoftDeleter
  belongs_to :user
  has_many :sections, dependent: :destroy
end
