class AnswersController < ApplicationController
  def new
    @profile = current_user.profile
    @questions = [
      "Q1.アウトドア派ですか？",
      "Q2.ご飯を食べることが好きですか？",
      "Q3.食事は、割り勘派ですか？"
    ]
    @answers = current_user.answers.build
  end

  def create
    @answers = current_user.answers.build(answer_params)
    if @answers.save
      redirect_to pages_show_path, notice: '回答が保存されました。'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :response)
  end
end
