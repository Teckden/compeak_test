require 'rails_helper'

RSpec.describe Submitter, :type => :model do

  context 'associations' do
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.to_not allow_value('not@valid_email').for(:email) }

    it 'has a valid factory' do
      submitter = FactoryGirl.build(:submitter)
      expect(submitter.valid?).to eq(true)
    end
  end
end
