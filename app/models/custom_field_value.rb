class CustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field

  validate :value_matches_field_type

  private

  # Custom validation to ensure the value matches the field type
  def value_matches_field_type
    case custom_field.field_type
    when 'number'
      errors.add(:value, "must be a number") unless value.to_s.match?(/\A-?\d+(\.\d+)?\z/)
    when 'enum'
      options = custom_field.options_array
      if options.nil?
        errors.add(:custom_field, "is invalid")
      elsif !options.include?(value)
        errors.add(:value, "must be one of: #{options.join(', ')}")
      end
    end
  end
end
