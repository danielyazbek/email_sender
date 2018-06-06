RSpec.describe Email, type: :model do
  describe 'Validations' do
    let(:email) {build :email}

    it 'is valid if all attributes are valid' do
      expect(email).to be_valid
    end

    it 'is invalid without a from address' do
      email.from = nil
      expect(email).not_to be_valid
    end

    it 'is invalid without a to address' do
      email.to = []
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
