class ChatsController < ApplicationController

  before_action :find_chat, only: [:show, :edit, :update, :destroy]

  def index
    @chats = Chat.all.order("created_at DESC")
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
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
  end

  private

  def chat_params
    params.require(:chat).permit(:name)
  end

  def find_chat
    @chat = Chat.find(params[:id])
  end
end
