class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy, :join]
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @users = User.group_members(@group)
    @games = Game.all

    if user_signed_in?
      @grouping = Grouping.where(user_id:current_user.id,group_id:@group.id).first
    end

    if @grouping && @grouping.admin
      @invitations = Invite.where(group_id:@group.id)
    end

    @location = @group.location
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  def join
    respond_to do |format|
      if @group.users << current_user
        format.json { render json: {} }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  def leave
    respond_to do |format|
      if @group.users.delete(current_user)
        format.json { render json: {} }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name,:info)
    end
end
