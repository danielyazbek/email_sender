class EmailAddressesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value_array)
    value_array.each do |value|
      unless EmailAddressValidator.is_valid_email_address?(value)
        record.errors[attribute] << (options[:message] || 'must contain valid email addresses')
        return
      end
    end
  end
end
