RSpec.describe SendAttempt, type: :model do
  describe 'Validations' do
    let(:email) {create :email}
    let(:send_attempt) {create :send_attempt, email: email}

    it 'is valid of all attributes are valid' do
      expect(send_attempt).to be_valid
    end

    it 'is valid with a provider of sendgrid or mailgun' do
      send_attempt.provider = 'sendgrid'
      expect(send_attempt).to be_valid
      send_attempt.provider = 'mailgun'
      expect(send_attempt).to be_valid
    end

    it 'is invalid without belonging to an email' do
      send_attempt.email = nil
      expect(send_attempt).not_to be_valid
    end

    it 'is invalid without a provider' do
      send_attempt.provider = nil
      expect(send_attempt).not_to be_valid
    end

    it 'is invalid without an attempt' do
      send_attempt.attempt = nil
      expect(send_attempt).not_to be_valid
    end

    it 'is invalid with attempt value 0' do
      send_attempt.attempt = 0
      expect(send_attempt).not_to be_valid
    end

    it 'is invalid with negative attempt value' do
      send_attempt.attempt = -1
      expect(send_attempt).not_to be_valid
    end

    it 'is invalid without a successful' do
      send_attempt.successful = nil
      expect(send_attempt).not_to be_valid
    end
  end

  describe 'Attempt' do
    let!(:email) {create :email}
    let!(:send_attempt) {create :send_attempt, email: email}
    it 'is initialized automatically' do
      expect(send_attempt.attempt).to be 1
      second = SendAttempt.create! email: email
      expect(second.attempt).to be 2
      third = SendAttempt.create! email: email
      expect(third.attempt).to be 3
    end
  end

  describe 'Provider' do
    let(:email) {create :email}
    let(:send_attempt) {create :send_attempt, email: email}
    it 'it rotates automatically' do
      expect(send_attempt.sendgrid?).to be true
      second = SendAttempt.create! email: email
      expect(second.mailgun?).to be true
      third = SendAttempt.create! email: email
      expect(third.sendgrid?).to be true
    end
  end
end
