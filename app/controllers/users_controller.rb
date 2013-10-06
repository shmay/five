class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:invite]
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    current_user = user_signed_in? ? current_user : nil
    @errors,@users,@within,@order_them,@loc,@zip,@games,@selected_games = User.index(params,current_user)
  end

  def show
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)

    @user = User.find params[:id]
    @location = @user.location
    @games = @user.games
    @groups = Group.users_groups(@user)
  end

  def invite
    @group = Group.find params[:group_id]
    invitee = User.find params[:id]

    error_message = ""
    invite = nil

    if Grouping.where(user_id:current_user.id,group_id:@group.id,admin:true).first
      if Invite.where(group_id:@group,user_id:current_user,invitee_id:invitee.id).first
        error_message = "Maybe I'm high, but according to the computery stuff I just performed, such an invite already exists."
      else
        invite = Invite.create(group_id:@group.id,user_id:current_user.id, invitee_id:invitee.id)
      end
    else
      error_message = "The f'n h bro?  You are not allowed to send invites for this group."
    end

    respond_to do |format|
      if invite
        format.json { render json: {} }
      else
        format.json { render json: {message:error_message}, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_path(@user), notice: 'Game was successfully updated.' }
        format.json { render json: @user }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def ensure_correct_user
      if current_user.id != @user.id
        redirect_to profile_path(@user), notice: 'You are not this user'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :info)
    end
end
