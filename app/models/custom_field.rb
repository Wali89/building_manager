class CustomField < ApplicationRecord
  belongs_to :client
  has_many :custom_field_values

  validates :name, presence: true
  validates :field_type, presence: true, inclusion: { in: %w(number freeform enum) }
  validates :options, presence: true, if: :enum?

  before_save :downcase_attributes

  # Check if the field type is enum
  def enum?
    field_type == 'enum'
  end

  # Return an array of options for enum fields
  def options_array
    options.split(',').map(&:strip).map(&:downcase) if enum?
  end

  private

  # Downcase all relevant attributes before saving
  def downcase_attributes
    self.name = name.downcase if name.present?
    self.field_type = field_type.downcase if field_type.present?
    self.options = options.downcase if options.present?
  end
end