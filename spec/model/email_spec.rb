RSpec.describe Email, type: :model do
  describe 'Validations' do
    let(:email) {build :email}

    it 'is valid if all attributes are valid' do
      expect(email).to be_valid
    end

    it 'is invalid without a to address' do
      email.to_addresses = []
      expect(email).not_to be_valid
    end

    it 'is invalid without a subject' do
      email.subject = ''
      expect(email).not_to be_valid
    end

    it 'is invalid without a body' do
      email.body = ''
      expect(email).not_to be_valid
    end

    it 'is invalid with an bad to address' do
      email.to_addresses = ['bad_email@']
      expect(email).not_to be_valid
    end

    it 'is invalid with a bad cc address' do
      email.cc_addresses = ['bad_email@']
      expect(email).not_to be_valid
    end

    it 'is invalid with a bad bcc address' do
      email.bcc_addresses = ['bad_email@']
      expect(email).not_to be_valid
    end

    describe 'Serialization' do
      it 'supports multiple to addresses' do
        email = build(:email, num_to: 3)
        expect(email.to_addresses.count).to be 3
        expect(email).to be_valid
      end

      it 'supports multiple cc addresses' do
        email = build(:email, num_cc: 3)
        expect(email.cc_addresses.count).to be 3
        expect(email).to be_valid
      end

      it 'supports multiple bcc addresses' do
        email = build(:email, num_bcc: 3)
        expect(email.bcc_addresses.count).to be 3
        expect(email).to be_valid
      end
    end
  end
end
