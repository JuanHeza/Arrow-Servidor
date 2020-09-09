require 'telegram/bot'
 
class TelegramEvent
    def initialize(params:)
        @params = params
    end
    def process
        telegram_api.send_message(
            chad_id: params["message"]["chat"]["id"],
            text: "hello, #{params["message"]["text"]}",
        )
    end

    private

    def telegram_api
        Telegram::Bot::Client.new(ENV.fetch("TELEGRAM_BOT_TOKEN")).api
    end
end