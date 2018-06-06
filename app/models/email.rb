class Email < ApplicationRecord
  include AASM

  has_one :from, class_name: 'EmailAddress', foreign_key: 'from_email_id'
  has_many :to, class_name: 'EmailAddress', foreign_key: 'to_email_id', index_errors: true
  has_many :cc, class_name: 'EmailAddress', foreign_key: 'cc_email_id', index_errors: true
  has_many :bcc, class_name: 'EmailAddress', foreign_key: 'bcc_email_id', index_errors: true
  has_many :send_attempts

  accepts_nested_attributes_for :from
  accepts_nested_attributes_for :to
  accepts_nested_attributes_for :cc
  accepts_nested_attributes_for :bcc

  validates :from, presence: true
  validates :to, presence: true
  validates :subject, presence: true
  validates :body, presence: true

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
end
