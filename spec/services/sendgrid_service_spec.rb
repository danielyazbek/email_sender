RSpec.describe SendgridService, type: :service do
  before do
    SendAttempt.skip_callback(:create, :before, :init_attempt)
  end

  after do
    SendAttempt.set_callback(:create, :before, :init_attempt)
  end

  describe 'send_email' do
    let(:email) {create :email}
    let(:sendgrid_attempt) {create :send_attempt, email: email, provider: :sendgrid, attempt: 1}
    let(:mailgun_attempt) {create :send_attempt, email: email, provider: :mailgun, attempt: 2}

    it 'only handles send attempts for the mailgun service' do
      expect(sendgrid_attempt.sendgrid?).to be true
      expect(mailgun_attempt.sendgrid?).to be false
      expect{SendgridService.send_email(email, mailgun_attempt)}.to raise_error(ArgumentError, 'send attempt not intended for this service')
    end

    it 'marks the send attempt as successful when the email was delivered' do
      http_connection = Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post('') {[202, {"x-message-id": 'some_message_id'}, '']}
        end
      end
      allow(SendgridService).to receive(:connection).and_return(http_connection)

      success, message = SendgridService.send_email(email, sendgrid_attempt)
      expect(success).to be true
      expect(message).to eq ''
      expect(sendgrid_attempt.successful).to be true
      expect(sendgrid_attempt.provider_id).to eq 'some_message_id'
      expect(sendgrid_attempt.provider_message).to be nil
    end

    it 'marks the send attempt as unsuccessful when the email was not delivered' do
      http_connection = Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post('') {[400, {}, '']}
        end
      end
      allow(SendgridService).to receive(:connection).and_return(http_connection)

      success, message = SendgridService.send_email(email, sendgrid_attempt)
      expect(success).to be false
      expect(message).to eq 'Mail not delivered via Sendgrid. Response status: 400'
      expect(sendgrid_attempt.successful).to be false
      expect(sendgrid_attempt.provider_id).to be nil
      expect(sendgrid_attempt.provider_message).to be nil
    end
  end

end
