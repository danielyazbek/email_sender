RSpec.describe Api::V1::EmailsController, type: :controller do

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      it 'creates a new email and queues it for processing' do
        from = Faker::Internet.email
        to = Faker::Internet.email
        cc = Faker::Internet.email
        bcc = Faker::Internet.email
        subject = Faker::Movie.quote
        body = Faker::Hipster.paragraph(5)
        request = {
          from_attributes: {email: from},
          to_attributes: [{email: to}],
          cc_attributes: [{email: cc}],
          bcc_attributes: [{email: bcc}],
          subject: subject,
          body: body
        }

        post :create, params: request
        expect(response.code).to eq '200'
        resp = JSON.parse(response.body)
        expect(resp['id']).not_to be_nil

        expect(Email.count).to be 1
        email = Email.first
        expect(email.from.email).to eq from
        expect(email.to.count).to eq 1
        expect(email.to.first.email).to eq to
        expect(email.cc.count).to eq 1
        expect(email.cc.first.email).to eq cc
        expect(email.bcc.count).to eq 1
        expect(email.bcc.first.email).to eq bcc
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
        expect(resp['errors']['from']).not_to be nil
        expect(resp['errors']['to']).not_to be nil
        expect(resp['errors']['subject']).not_to be nil
        expect(resp['errors']['body']).not_to be nil
        expect(EmailDeliveryWorker.jobs.size).to eq 0
      end
    end
  end

  describe 'GET index' do
    it 'returns ALL the emails in the system for rendering' do
      email_1 = create :email
      email_2 = create :email
      email_3 = create :email

      get :index
      expect(response.code).to eq '200'
      resp = JSON.parse(response.body)

      expect(resp.instance_of?(Array)).to be true
      expect(resp.length).to be 3
      verify_json(resp[0], email_3)
      verify_json(resp[1], email_2)
      verify_json(resp[2], email_1)
    end
  end

  private

  def verify_json(json, email)
    expect(json['id']).to eq email.id
    expect(json['state']).to eq email.aasm_state
    expect(json['from_address']).to eq email.from.email
    expect(json['to_addresses']).to eq email.to.map{|e| e.email}
    expect(json['cc_addresses']).to eq email.cc.map{|e| e.email}
    expect(json['bcc_addresses']).to eq email.bcc.map{|e| e.email}
    expect(json['subject']).to eq email.subject
    expect(json['body']).to eq email.body
  end

end
