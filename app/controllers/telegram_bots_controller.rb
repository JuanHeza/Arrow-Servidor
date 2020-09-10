require "telegram/bot"

class TelegramBotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  Comands = ["/start", "/status", "/toggleAlert", "/getSeries", "/setSerie", "/stop"]
  test_series = ["Basico", "Rojo", "Blanco", "Azul", "Verde", "Friends"]

  def test
    request.body.rewind
    data = JSON.parse(request.body.read)
    @bot = Telegram::Bot::Api.new(ENV["TELEGRAM_BOT_API_TOKEN"])
    @message = Telegram::Bot::Types::Update.new(data).message
    pp data
    pp "Message received: #{@message.inspect}"
    case message
    when Telegram::Bot::Types::CallbackQuery
      puts message.data
      puts message.message.text
      bot.api.send_message(chat_id: message.from.id, text: "Serie #{message.data} iniciada")
    when Telegram::Bot::Types::Message
      case message.text
      when "/start"
        list = []
        for i in 0..Comands.size
          list.push(Comands[i * 2, 2])
          if list.size * 2 > Comands.size
            break
          end
        end
        answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: list, one_time_keyboard: true)
        bot.api.send_message(chat_id: message.chat.id, text: "Bienvenido aqui puedes controlar el estado de las alertas del sistema :)", reply_markup: answers)
      when "/status"
        bot.api.send_message(chat_id: message.chat.id, text: "La Alerta esta #{AlertsController.alertStatus} y se esta ejecutando la secuencia: #{AlertsController.actualSerie}")
      when "/alerttoggle"
        AlertsController.alertstatus = AlertsController.alertstatus
      when "/getserie"
        bot.api.send_message(chat_id: message.chat.id, text: "La serie actual es: #{alertstatus.actualSerie}")
        #implementar un gif de la serie
      when "/setSerie"
        kb = []
        Alert.all.each do
          |alert|
          kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: alert.titulo, callback_data: alert.id))
        end
        answers = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        bot.api.send_message(chat_id: message.chat.id, text: "Series:", reply_markup: answers)
      when "/stop"
        kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.username}", reply_markup: kb)
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Lo siento #{message.from.username}, Comando no reconocido.")
      end
    end
  end
end
