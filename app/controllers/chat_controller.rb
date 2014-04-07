class ChatController < WebsocketRails::BaseController
  def initialize_session
    # Controller initialization. Run once in the whole server lifetime.
  end

  def client_connected
    puts "Client connected"
  end

  def delete_user
    puts "Client disconnected"
  end

  def new_message
    broadcast_message :message_received, message
  end
end
