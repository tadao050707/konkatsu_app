class PagesController < ApplicationController
  def index
    @profile = Profile.find(params[:id])
  end

  def show
    @profile = current_user.profile
    unless @profile.user == current_user
      redirect_to pages_show_path
    end
  end
end
