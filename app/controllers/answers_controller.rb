class AnswersController < ApplicationController
  def new
    @profile = current_user.profile
    @questions = Question.all
    @answers = current_user.answers.build
  end

  def create
    binding.pry
    answer_data = params[:answers].values.map { |value| value[:response] }
    @answers = current_user.answers.build(response: answer_data)

    if @answers.save
      redirect_to pages_show_path, notice: '回答が保存されました。'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answers).permit(:response)
  end
end
