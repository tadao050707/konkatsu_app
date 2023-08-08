class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    if current_user && current_user.profile
      if current_user.profile.sex == 'man'
        # ログインしているユーザーが男性の場合は、女性のプロフィールのみを表示
        @profiles = Profile.where.not(id: current_user.profile.id, sex: 'man').page(params[:page]).per(50).order("created_at DESC")
      elsif current_user.profile.sex == 'woman'
        # ログインしているユーザーが女性の場合は、男性のプロフィールのみを表示
        @profiles = Profile.where.not(id: current_user.profile.id, sex: 'woman').page(params[:page]).per(50).order("created_at DESC")
      else
        # ログインしているユーザーが性別を選択していない場合は全てのプロフィールを表示
        @profiles = Profile.page(params[:page]).per(50).order("created_at DESC")
      end
    else
      # プロフィールを作成していない場合は、プロフィール作成ページへ飛ばす
      redirect_to new_profile_path
    end
  end


  def show
    @profile = Profile.find(params[:id])
    @icon_url = @profile.icon.present? ? @profile.icon.url : Profile.default_icons.sample

    @user_answers = current_user.answers.includes(:question)
    @profile_answers = @profile.user.answers.includes(:question)

    # 質問ごとに一致している回答をカウント
    @compatibility_score = 0
    @user_answers.each_with_index do |user_answer, index|
      @compatibility_score += 1 if user_answer.response == @profile_answers[index].response
    end

    # 相性率を計算
    total_score = @user_answers.length
    @compatibility_percentage = (@compatibility_score.to_f / total_score * 100).round(2)
  end

  def new
    if current_user.profile.nil?
      @profile = Profile.new(name: "名無し")
    else
      redirect_to profile_path(current_user.profile)
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    unless @profile.user == current_user
      redirect_to profiles_path
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id

    if @profile.icon.blank?
      @profile.icon = Profile.default_icons.sample
    end

    respond_to do |format|
      if @profile.save
        format.html { redirect_to new_answer_path(current_user), notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to pages_show_path(current_user), notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_profile
      @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:icon, :name, :age, :work, :hobby, :likes, :free, :comment, :sex)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end


