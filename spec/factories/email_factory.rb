FactoryBot.define do
  factory :email do
    transient do
      num_to 1
      num_cc 0
      num_bcc 0
    end

    to_addresses { Array.new(num_to) {Faker::Internet.email} }
    cc_addresses { Array.new(num_cc) {Faker::Internet.email} }
    bcc_addresses { Array.new(num_bcc) {Faker::Internet.email} }

    subject { Faker::Movie.quote }
    body { Faker::Hipster.paragraph(5) }
  end
end
