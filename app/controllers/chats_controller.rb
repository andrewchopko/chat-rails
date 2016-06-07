class ChatsController < ApplicationController

  before_action :find_chat, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  def index
    if user_signed_in?
      @chats = Chat.find_by_sql(["SELECT * FROM chats WHERE (user_id = :id OR admin_id = :id)", {:id => current_user.id.to_s}])
    end
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.admin_id = current_user.id
    @chat.unread_messages = 0

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
    params.require(:chat).permit(:name, :user_id)
  end

  def find_chat
    @chat = Chat.find(params[:id])
  end
end
