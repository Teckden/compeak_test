require 'rails_helper'

RSpec.describe Message, :type => :model do
  context 'associations' do
    it { is_expected.to belong_to(:submitter) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:content) }

    it 'has a valid factory' do
      message = FactoryGirl.build :message
      expect(message.valid?).to eq true
    end
  end
end
