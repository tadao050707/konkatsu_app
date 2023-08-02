class ChatsController < ApplicationController
  before_action :set_user_and_reject_non_related, only: [:show]


  def index
    @rooms = current_user.rooms
    @chat_partner_profile = @user.profile
    #チャット相手の名前
    @chat_partner_name = @chat_partner_profile.name
  end

  def show
    @profile = Profile.find(params[:id])
    @rooms = current_user.user_rooms.pluck(:room_id)
    @user_rooms = UserRoom.find_by(user_id: current_user.id, room_id: @rooms)

    unless @user_rooms.nil?
      @room = @user_rooms.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @profile.user.id, room_id: @room.id)
    end
    #ログインしているユーザーのプロフィール
    @current_user_profile = current_user.profile
    #チャット相手のプロフィール
    @chat_partner_profile = @user.profile
    #チャット相手の名前
    @chat_partner_name = @chat_partner_profile.name

    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    # メッセージを保存し、元のURLへリダイレクト
    @chat = current_user.chats.new(chat_params)
    @chat.save
    redirect_to request.referer
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def set_user_and_reject_non_related
    @user = User.find(params[:id])
    reject_non_related unless current_user.following?(@user) && @user.following?(current_user)
  end

  def reject_non_related
    redirect_to profiles_path
  end
end
