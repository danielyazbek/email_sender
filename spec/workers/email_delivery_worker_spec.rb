RSpec.describe EmailDeliveryWorker, type: :worker do
  describe 'perform' do
    it 'alternates between the Sendgrid and Mailgun email services' do
      email_1 = create :email
      email_2 = create :email
      email_3 = create :email
      email_4 = create :email

      allow(SendgridService).to receive(:send_email).once.and_return(true, '')
      EmailDeliveryWorker.new.perform(email_1.id)
      email_1.reload
      expect(email_1.successful?).to be true

      allow(MailgunService).to receive(:send_email).once.and_return(true, '')
      EmailDeliveryWorker.new.perform(email_2.id)
      email_2.reload
      expect(email_2.successful?).to be true

      allow(SendgridService).to receive(:send_email).once.and_return(true, '')
      EmailDeliveryWorker.new.perform(email_3.id)
      email_3.reload
      expect(email_3.successful?).to be true

      allow(MailgunService).to receive(:send_email).once.and_return(true, '')
      EmailDeliveryWorker.new.perform(email_4.id)
      email_4.reload
      expect(email_4.successful?).to be true
    end

    it 'raises an error if the provider could not deliver' do
      email = create :email
      allow(SendgridService).to receive(:send_email).once.and_return(false, 'Some reason')
      expect{EmailDeliveryWorker.new.perform(email.id)}.to raise_error(StandardError)
      email.reload
      expect(email.pending?).to be true
    end
  end

end
