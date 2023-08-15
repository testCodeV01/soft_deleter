class Section < ApplicationRecord
  include SoftDeleter
  belongs_to :book
end
