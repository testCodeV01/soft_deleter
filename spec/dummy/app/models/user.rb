class User < ApplicationRecord
  include SoftDeleter

  has_many :books, dependent: :destroy
  has_one_attached :avatar
  has_many_attached :pdf

  exclude_dependent :pdf, sufix: :attachments
  exclude_dependent :avatar, sufix: :attachment

  validates :name, presence: true
end
