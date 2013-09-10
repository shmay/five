class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:invite]
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    game_ids = []
    @errors = []
    @games = Game.all

    if user_signed_in? && params[:invite_group] && params[:invite_group].to_i > 0
      if Grouping.where(group_id:params[:invite_group].to_i,user_id: current_user.id, admin:true).first
        @invite_group = Group.find_by_id(params[:invite_group].to_i)
      end
    end

    @zip = params[:zip].to_i == 0 ? nil : params[:zip]
    @within = params[:within].to_i == 0 ? nil : params[:within].to_i
    @order_them = false

    select = ['users.id AS id', 'users.name AS name', :current_sign_in_at]

    if @zip
      @loc = Geokit::Geocoders::Google3Geocoder.geocode @zip
      @order_them = true
    elsif user_signed_in? && current_user.location
      @loc = Geokit::Geocoders::Google3Geocoder.geocode current_user.location.zip
    end

    if @loc && !@loc.city
      @errors << "Couldn't find that zip!  Query was not performed.  Thank you, come again."
    end

    if @errors.empty?
      @users = User.query_users(@loc,game_ids,@within,@order_them,@invite_group)
    end
    Five::Query.handle_params_then_get_models(params, user_signed_in? ? current_user : nil)
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
        error_message = "Maybe I'm just high, but according to the computery stuff I just performed, such an invite already exists."
      else
        invite = Invite.create(group_id:@group.id,user_id:current_user.id, invitee_id:invitee.id)
      end
    else
      error_message = "The f'n h breh?  You are not allowed to send invites for this group."
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
