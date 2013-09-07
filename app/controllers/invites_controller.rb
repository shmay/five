class InvitesController < ApplicationController
  before_action :set_invite, only: [:destroy]

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    respond_to do |format|
      if @invite.destroy
        format.json { head :no_content }
      else
        format.json { head :no_content, status: :unprocessable_entity}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = Invite.find(params[:id])
    end
end
