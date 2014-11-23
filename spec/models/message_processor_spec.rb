require 'rails_helper'

RSpec.describe MessageProcessor, type: ActiveModel do

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.to_not allow_value('not@valid_email').for(:email) }
  end

  context 'when processing data' do
    let(:file_path) { MessageProcessor::CSV_FILE_PATH }
    let(:message_processor) { MessageProcessor.new(
        name: 'John Doe',
        email: 'user@example.com',
        subject: 'Finance',
        content: 'Message Content'
    )}

    before(:each) { message_processor.export_to_csv }
    after(:each) { File.truncate(file_path, 0) }

    context ' when exporting data to the csv' do
      let(:valid_csv_headers) { MessageProcessor::VALID_CSV_HEADERS }

      it 'should create a file if it does not exist' do
        expect(File.exist?(file_path)).to eq(true)
      end

      it 'should export headers' do
        headers = CSV.read(file_path, headers: true).headers
        expect(headers).to eq(valid_csv_headers)
      end

      it 'should export data' do
        param_values = message_processor.as_json.values_at(*valid_csv_headers)
        expect(CSV.read(file_path).last).to eq(param_values)
      end
    end

    context 'when importing data from csv' do
      it 'should create record in messages' do
        expect{ MessageProcessor.import_to_db }.to change{ Message.count }.by(1)
      end

      it 'should clean up csv file' do
        expect{ MessageProcessor.import_to_db }.to change{
          csv_lines = CSV.readlines(file_path)
          csv_lines.count
        }.by(-2)
      end

      it 'should create association with submitter' do
        MessageProcessor.import_to_db
        submitter = Submitter.where(email: message_processor.email).first

        expect(Message.last.submitter).to_not be(nil)
        expect(Message.last.submitter).to eq(submitter)
      end

      it 'should create submitter when Submitter does not exist' do
        expect{ MessageProcessor.import_to_db }.to change{ Submitter.count }.by(1)
        expect(Submitter.last.email).to eq(message_processor.email)
      end

      it 'should not create submitter when Submitter exist' do
        FactoryGirl.create(:submitter, email: message_processor.email)
        expect{ MessageProcessor.import_to_db }.to change{ Submitter.count }.by(0)
      end
    end
  end
end
