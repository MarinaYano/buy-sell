class MessagesController < ApplicationController
    before_action :authenticate_user!, :only => [:create]

  def create
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
      redirect_to "/rooms/#{@message.room_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def index
    # 送られたユーザーでないと表示できないように
    if current_user.id.to_i == params[:id].to_i
      @user = User.find_by(id: params[:id])
　　　 # messageをしているユーザーのidを配列で取得その後に自分のは削除。これで一覧でどのユーザーに対してのDMかを表示させる
      @message_user_ids = Message.where(to_user_id: @user.id).or(Message.where(user_id: @user.id)).distinct.pluck(:user_id)
      @message_user_ids.delete(@user.id)
    else
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end

  def roomshow
    if current_user.id.to_i == params[:user_id].to_i
      @to_user_id = params[:to_user_id]
      @messages = Message.where(user_id: params[:user_id],to_user_id: @to_user_id).or(Message.where(user_id: params[:to_user_id],to_user_id: params[:user_id])).order(created_at: :asc)
      unread_messages = Message.where(to_user_opentime: nil,to_user_id: current_user.id)
      unread_messages.each do |unread_message|
        unread_message.to_user_opentime = Date.today.to_time
        unread_message.save
      end
    else
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
  
end
