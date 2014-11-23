class MessagesController < ApplicationController

  def index
    @messages = Message.includes(:submitter).order('id desc').page(params[:page])
  end

  def new
    @message = MessageProcessor.new
  end

  def destroy
    Message.find(params[:id]).destroy
    redirect_to messages_path, notice: 'Message is successfully deleted'
  end

  def create_csv_record
    @message = MessageProcessor.new(message_params)
    if @message.valid?
      @message.export_to_csv
      redirect_to messages_path, notice: 'Successfully sent'
    else
      render :new
    end
  end

  def import_to_db
    messages = MessageProcessor.import_to_db
    redirect_to messages_path, notice: "#{messages.count} messages have been successfully imported"
  end

  private

  def message_params
    params.require(:message_processor).permit(:name, :email, :subject, :content)
  end
end
