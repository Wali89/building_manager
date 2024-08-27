class Client < ApplicationRecord
  has_many :buildings
  has_many :custom_fields

  validates :name, presence: true, uniqueness: true
end
