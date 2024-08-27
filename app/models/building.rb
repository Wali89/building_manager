class Building < ApplicationRecord
  belongs_to :client
  has_many :custom_field_values, dependent: :destroy

  accepts_nested_attributes_for :custom_field_values

  validates :address, presence: true, on: :create
  validate :address_unique_for_client, on: :create

  private

  # Custom validation to ensure address is unique for a client
  def address_unique_for_client
    if client.buildings.where(address: address).exists?
      errors.add(:address, "already exists for this client")
    end
  end
end