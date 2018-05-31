class EmailAddressesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value_array)
    value_array.each do |value|
      unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors[attribute] << (options[:message] || 'is not an array of emails')
        return
      end
    end
  end
end
