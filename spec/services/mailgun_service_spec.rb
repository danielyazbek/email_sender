RSpec.describe MailgunService, type: :service do

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
      expect{MailgunService.send_email(email, sendgrid_attempt)}.to raise_error(ArgumentError, 'send attempt not intended for this service')
    end

    it 'marks the send attempt as successful when the email was delivered' do
      mock_response = {
        id: "<20180601083554.1.CF8BF210DE42C936@sandbox180c6c4fcf064f008561a0798e61ae2f.mailgun.org>",
        message: 'Queued. Thank you.'
      }
      http_connection = Faraday.new do |builder|
        builder.response :json
        builder.adapter :test do |stubs|
          stubs.post('') {[200, {}, mock_response.to_json]}
        end
      end
      allow(MailgunService).to receive(:connection).and_return(http_connection)

      success, message = MailgunService.send_email(email, mailgun_attempt)
      expect(success).to be true
      expect(message).to eq ''
      expect(mailgun_attempt.successful).to be true
      expect(mailgun_attempt.provider_id).to eq mock_response[:id]
      expect(mailgun_attempt.provider_message).to eq mock_response[:message]
    end

    it 'marks the send attempt as unsuccessful when the email was not delivered' do
      http_connection = Faraday.new do |builder|
        builder.response :json
        builder.adapter :test do |stubs|
          stubs.post('') {[400, {}, '']}
        end
      end
      allow(MailgunService).to receive(:connection).and_return(http_connection)

      success, message = MailgunService.send_email(email, mailgun_attempt)
      expect(success).to be false
      expect(message).to eq 'Mail not be delivered via Mailgun. Response status: 400'
      expect(mailgun_attempt.successful).to be false
      expect(mailgun_attempt.provider_id).to be nil
      expect(mailgun_attempt.provider_message).to be nil
    end
  end
end
