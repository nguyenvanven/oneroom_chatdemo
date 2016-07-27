class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    @message = Message.new message_params
    @message.ip = request.remote_ip
    @message.save!
    ActionCable.server.broadcast 'messages', message: render_message(@message)
    redirect_to messages_path
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    ApplicationController.render(
      partial: 'messages/message',
      locals: {message: message}
    )
  end
end
