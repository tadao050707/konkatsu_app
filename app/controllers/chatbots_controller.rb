class ChatbotsController < ApplicationController

  def index
    @profile = current_user.profile
    #chatGPT
    @user = User.find_by(id: current_user.id)
    # @profile = @user.profile
    likes = @profile.likes
    hobby = @profile.hobby
    work = @profile.work

    @query = "自分が楽しい、嬉しいと思うことは#{likes}です。趣味は#{hobby}です。仕事は#{work}です。私を一言で表すと何になりますか？ニックネームをつけてください"

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    response = client.chat(
        parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: @query }],
      }
    )
    @answer = response.dig("choices", 0, "message", "content")
  end
end
