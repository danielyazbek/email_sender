class SendAttempt < ApplicationRecord
  enum provider: {sendgrid: 0, mailgun: 1}

  belongs_to :email

  validates :email, presence: true
  validates :provider, presence: true, inclusion: { in: providers.keys }, on: :update
  validates :attempt, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :email }, on: :update
  validates :successful, inclusion: { in: [true, false] }

  before_create :init_attempt

  private

  def init_attempt
    self.attempt = self.email.try(:send_attempts).try(:count).try(:+, 1) || 1
    self.provider = self.class.providers.keys[self.attempt % 2 - 1]
  end
end
