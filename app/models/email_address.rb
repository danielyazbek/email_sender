class EmailAddress < ApplicationRecord

  validates :email, presence: true, email_address: true
end
