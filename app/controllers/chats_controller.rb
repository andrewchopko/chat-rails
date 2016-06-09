class ChatsController < ApplicationController

  before_action :find_chat, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  def index
    if user_signed_in?
      @chats = Chat.find_by_sql(["SELECT * FROM chats WHERE (user_id = :id OR admin_id = :id)", {:id => current_user.id.to_s}])
      @users = User.all
    end

    respond_to do |format|
      format.html
      format.json {render json: @chats, status: 200}
    end
  end

  def new
    @chat = Chat.new
    respond_to do |format|
      format.html
      format.json {render json:@chat, status: :ok}
    end
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.admin_id = current_user.id
    @chat.unread_messages = 0
    @chat.unread_messages_admin = 0

    if @chat.save
      redirect_to @chat
      respond_to do |format|
        format.html
        format.json { render json: @chat, status: 201, location: @chat}
      end
    else
      render "new"
    end
  end

  def edit
  end

  def update
    @chat.update(chat_params)
    @user = User.find(@chat.user_id)
    @admin = User.find(@chat.admin_id)
    @chat.update_attribute(:unread_messages, count_unread_messages_for_user(@chat, @user))
    @chat.update_attribute(:unread_messages_admin, count_unread_messages_for_admin(@chat, @admin))
    redirect_to @chat
    respond_to do |format|
      format.html
      format.json { render json: @chat, status: 200}
    end
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
    @un_mes = 0
    @messages.each do |m|
      if(m.created_at.to_i > @user.current_sign_in_at.to_i)
        @un_mes += 1
      end
    end
    return @un_mes
  end

  def count_unread_messages_for_admin(chat, user)
    @messages = Message.find_by_sql(["SELECT * FROM messages WHERE (chat_id = :chat_id AND user_id = :admin_id)", {:chat_id => chat.id, :admin_id => chat.admin_id.to_s}])
    @user = User.find(user.id)
    @un_mes = 0
    @messages.each do |m|
      if(m.created_at.to_i > @user.current_sign_in_at.to_i)
        @un_mes += 1
      end
    end
    return @un_mes
  end
end
