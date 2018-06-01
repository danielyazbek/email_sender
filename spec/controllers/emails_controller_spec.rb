RSpec.describe Api::V1::EmailsController, type: :controller do

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      it 'creates a new email and queues it for processing' do
        from = Faker::Internet.email
        to = [Faker::Internet.email]
        cc = [Faker::Internet.email]
        bcc = [Faker::Internet.email]
        subject = Faker::Movie.quote
        body = Faker::Hipster.paragraph(5)
        request = {
          from_address: from,
          to_addresses: to,
          cc_addresses: cc,
          bcc_addresses: bcc,
          subject: subject,
          body: body
        }

        post :create, params: request
        expect(response.code).to eq '200'
        resp = JSON.parse(response.body)
        expect(resp['id']).not_to be_nil

        expect(Email.count).to be 1
        email = Email.first
        expect(email.from_address).to eq from
        expect(email.to_addresses).to eq to
        expect(email.cc_addresses).to eq cc
        expect(email.bcc_addresses).to eq bcc
        expect(email.subject).to eq subject
        expect(email.body).to eq body
        expect(EmailDeliveryWorker.jobs.size).to eq 1
      end
    end

    context 'when parameters are invalid' do
      it 'does nothing and returns errors' do
        request = {}
        post :create, params: request
        expect(response.code).to eq '400'
        resp = JSON.parse(response.body)
        expect(resp['id']).to be_nil
        expect(resp['errors']['from_address']).not_to be nil
        expect(resp['errors']['to_addresses']).not_to be nil
        expect(resp['errors']['subject']).not_to be nil
        expect(resp['errors']['body']).not_to be nil
        expect(EmailDeliveryWorker.jobs.size).to eq 0
      end
    end
  end

end
