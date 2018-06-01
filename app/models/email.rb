class Email < ApplicationRecord
  include AASM

  has_many :send_attempts

  serialize :to_addresses, Array
  serialize :cc_addresses, Array
  serialize :bcc_addresses, Array

  validates :from_address, presence: true, email_address: true
  validates :to_addresses, presence: true, email_addresses: true
  validates :cc_addresses, email_addresses: true
  validates :bcc_addresses, email_addresses: true
  validates :subject, presence: true
  validates :body, presence: true
  validate :duplicate_addresses

  aasm do
    state :pending, initial: true
    state :successful, :unsuccessful

    event :delivered do
      transitions from: :pending, to: :successful
    end

    event :failed do
      transitions from: :pending, to: :unsuccessful
    end
  end

  private

  def duplicate_addresses
    if (to_addresses & cc_addresses).any?
      errors.add(:cc_addresses, 'contains a duplicate email already defined in \'to_addresses\'')
    end
    if (to_addresses & bcc_addresses).any?
      errors.add(:bcc_addresses, 'contains a duplicate email already defined in \'to_addresses\'')
    end
    if (cc_addresses & bcc_addresses).any?
      errors.add(:bcc_addresses, 'contains a duplicate email already defined in \'cc_addresses\'')
    end
  end
end
