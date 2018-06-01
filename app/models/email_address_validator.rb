class EmailAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless self.class.is_valid_email_address?(value)
      record.errors[attribute] << (options[:message] || 'is not an email')
    end
  end

  def self.is_valid_email_address?(value)
    value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
