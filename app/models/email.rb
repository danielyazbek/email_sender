class Email < ApplicationRecord
  has_many :send_attempts

  serialize :to_addresses, Array
  serialize :cc_addresses, Array
  serialize :bcc_addresses, Array

  validates :to_addresses, presence: true, email_addresses: true
  validates :cc_addresses, email_addresses: true
  validates :bcc_addresses, email_addresses: true
  validates :subject, presence: true
  validates :body, presence: true
end
