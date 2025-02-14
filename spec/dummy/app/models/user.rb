class User < ApplicationRecord
  include SoftDeleter

  has_many :books, dependent: :destroy
  has_one_attached :avatar
  has_many_attached :pdfs

  exclude_dependent :pdfs, suffix: :attachments
  exclude_dependent :avatar, suffix: :attachment

  validates :name, presence: true
end
