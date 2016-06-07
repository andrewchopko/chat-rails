class ChatsController < ApplicationController

  before_action :find_chat, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  def index
    if user_signed_in?
      @chats = Chat.find_by_sql(["SELECT * FROM chats WHERE (user_id = :id OR admin_id = :id)", {:id => current_user.id.to_s}])
      @users = User.all
    end
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.admin_id = current_user.id
    @chat.unread_messages = 0
    @chat.unread_messages_admin = 0

    if @chat.save
      redirect_to @chat
    else
      render "new"
    end
  end

  def edit
  end

  def update
    @chat.update(chat_params)
    @chat.update_attribute(:unread_messages, 10)
    @chat.update_attribute(:unread_messages_admin, 25)
    redirect_to @chat
  end

  def destroy
    @chat.destroy
    redirect_to root_path
  end

  def show
    @messages = Message.where(chat_id: @chat.id)
    @users = User.all
  end

  private

  def chat_params
    params.require(:chat).permit(:name, :user_id, :unread_messages, :unread_messages_admin)
  end

  def find_chat
    @chat = Chat.find(params[:id])
  end

  def count_unread_messages_for_user(chat, user)
    @messages = Message.find_by_sql(["SELECT * FROM messages WHERE (chat_id = :chat_id AND user_id = :user_id)", {:chat_id => chat.id, :user_id => user.id}])
    @user = User.find(user.id)
    @const = 0
    @messages.each do |m|
      if(m.created_at.to_i > @user.current_sign_in_at.to_i)
        @const += 1
      end
    end
    return @const
  end
end
