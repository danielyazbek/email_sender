FactoryBot.define do
  factory :email do
    transient do
      num_to 1
      num_cc 0
      num_bcc 0
    end

    subject { Faker::Movie.quote }
    body { Faker::Hipster.paragraph(5) }
    after(:build) do |email, eval|
      email.from = build(:email_address)
      email.to = build_list(:email_address, eval.num_to)
      email.cc = build_list(:email_address, eval.num_cc)
      email.bcc = build_list(:email_address, eval.num_bcc)
    end
  end
end
