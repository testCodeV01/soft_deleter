class Book < ApplicationRecord
  include SoftDeleter
  belongs_to :user
  has_many :sections, dependent: :destroy
  has_one_attached :image

  exclude_dependent :image_attachment
end
