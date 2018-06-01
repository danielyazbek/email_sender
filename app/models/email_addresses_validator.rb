class EmailAddressesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value_array)
    value_array.each do |value|
      unless EmailAddressValidator.is_valid_email_address?(value)
        record.errors[attribute] << (options[:message] || 'is not an array of emails')
        return
      end
    end
  end
end
