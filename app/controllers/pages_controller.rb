class PagesController < ApplicationController
  def index
    @profile = Profile.find(params[:id])
  end

  def show
    @profile = current_user.profile
  end
end
