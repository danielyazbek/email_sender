RSpec.describe Email, type: :model do
  describe 'Validations' do
    let(:email) {build :email}

    it 'is valid if all attributes are valid' do
      expect(email).to be_valid
    end

    it 'is invalid without a from address' do
      email.from_address = ''
      expect(email).not_to be_valid
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

    it 'is invalid with a bad from address' do
      email.from_address = 'bad_email@'
      expect(email).not_to be_valid
    end

    it 'is invalid with a bad to address' do
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

    it 'is invalid when the same email address is used in to_addresses and cc_addresses' do
      addr = Faker::Internet.email
      email.to_addresses = [addr]
      email.cc_addresses = [addr]
      expect(email).not_to be_valid
    end

    it 'is invalid when the same email address is used in to_addresses and bcc_addresses' do
      addr = Faker::Internet.email
      email.to_addresses = [addr]
      email.bcc_addresses = [addr]
      expect(email).not_to be_valid
    end

    it 'is invalid when the same email address is used in cc_addresses and bcc_addresses' do
      addr = Faker::Internet.email
      email.cc_addresses = [addr]
      email.bcc_addresses = [addr]
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

  describe 'State Machine' do
    let(:email) {create :email}

    it 'has an initial state of pending' do
      expect(email).to have_state(:pending)
    end

    it 'allows transition from pending to successful on delivered event' do
      expect(email).to allow_event :delivered
      expect(email).to transition_from(:pending).to(:successful).on_event(:delivered)
    end

    it 'allows transition from pending to unsuccessful on failed event' do
      expect(email).to allow_event :failed
      expect(email).to transition_from(:pending).to(:unsuccessful).on_event(:failed)
    end
  end
end
