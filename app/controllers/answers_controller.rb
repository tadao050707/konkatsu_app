class AnswersController < ApplicationController
  def new
    @profile = current_user.profile
    @questions = [
      "Q1.どちらかというとインドア派よりアウトドア派だ",
      "Q2.ファッションやグルメにこだわりがある",
      "Q3.一人でやる趣味が多い",
      "Q4.行動する前によく考える",
      "Q5.多少値段が高くても、気に入ったものは買うことが多い",
      "Q6.お酒は好きな方だ",
      "Q7.恋人と飲みにいくならお洒落なお店に行きたい",
      "Q8.スポーツはやるより観る方が好きだ",
      "Q9.本を読むことが好きだ",
      "Q10.些細なことで恋人と喧嘩をしたら自分から謝る方だ",
      "Q11.恋人ができたら服装や趣味を合わせる方だ",
      "Q12.恋人がいても自分の時間は欲しい",
      "Q13.ホラー映画は好きな方だ",
      "Q14.一人で旅行に行ったことがある、または行ってみたい",
      "Q15.全てを投げ出して、船で世界を旅しながら生活できたら楽しいと思うか"
    ]
    @answers = current_user.answers.build
  end

  def create
    @profile = current_user.profile
    answers = []
    params[:answers].each do |key, value|
      answers << value[:response]
    end
    @answers = current_user.answers.build(answer_params)
    @answers.response
    binding.pry
    if @answers.save
      redirect_to pages_show_path(current_user.profile), notice: '回答が保存されました。'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :response, :answers)
  end
end
