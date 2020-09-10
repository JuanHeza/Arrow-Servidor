class TelegramBotController < ApplicationController
  def test
    request.body.rewind
    data = JSON.parse(request.body.read)
    @bot = Telegram::Bot::Api.new(ENV['TELEGRAM_BOT_API_TOKEN'])
    @message = Telegram::Bot::Types::Update.new(data).message
    pp data
    pp "Message received: #{@message.inspect}"
  end
end
