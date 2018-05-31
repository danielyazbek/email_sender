FactoryBot.define do
  factory :send_attempt do
    provider :sendgrid
    attempt 1
    email
  end
end
