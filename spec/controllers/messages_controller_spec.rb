require 'rails_helper'

RSpec.describe MessagesController, :type => :controller do
  context 'GET index' do
    let(:message) { FactoryGirl.create(:message) }

    before(:each) { get :index }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'assigns messages to @messages' do
      expect(assigns[:messages]).to eq([message])
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  context 'GET new' do
    before(:each) { get :new }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end

    it 'assigns a new message as @message_processor' do
      expect(assigns[:message]).to be_a MessageProcessor
    end
  end

  context 'POST create' do
    context 'when valid params' do
      let(:valid_params) {
        {
            name: 'John Doe',
            email: 'user@example.com',
            subject: 'Finance',
            content: 'Content'
        }
      }

      before(:each) { post :create_csv_record, message_processor: valid_params }

      it 'redirects to the messages_path' do
        expect(response).to redirect_to messages_path
      end

      it 'assigns flash notice' do
        expect(flash[:notice]).to eq('Successfully sent')
      end
    end

    context 'when invalid params' do
      it 'renders new' do
        post :create_csv_record, message_processor: { name: '' }
        expect(response).to render_template :new
      end
    end
  end

  context 'GET import_to_db' do
    before(:each) do
      message = FactoryGirl.create(:message)
      expect(MessageProcessor).to receive(:import_to_db).and_return([message])
    end

    it 'redirects to messages_path' do
      get :import_to_db
      expect(response).to redirect_to messages_path
    end
    it 'assigns flash notice' do
      get :import_to_db
      expect(flash[:notice]).to eq('1 messages have been successfully imported')
    end
  end

  context 'DELETE destroy' do
    before :each do
      @submitter = FactoryGirl.create(:submitter_with_message)
      @message = @submitter.messages.last
    end

    it 'deletes message' do
      expect{ delete :destroy, id: @message.id }.to change{ Message.count }.by(-1)
    end
    it 'redirects to messages_path' do
      delete :destroy, id: @message.id
      expect(response).to redirect_to messages_path
    end
    it 'assigns flash notice' do
      delete :destroy, id: @message.id
      expect(flash[:notice]).to eq('Message is successfully deleted')
    end
  end
end
