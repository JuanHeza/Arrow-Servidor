class TelegramBotController < ApplicationController
  def test
    request.body.rewind
    data = JSON.parse(request.body.read)
    pp data
  end
end
