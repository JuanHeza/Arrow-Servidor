require "telegram/bot"

class TelegramBotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  Comands = ["/start", "/status", "/toggleAlert", "/getSeries", "/setSerie", "/stop"]
  test_series = ["Basico", "Rojo", "Blanco", "Azul", "Verde", "Friends"]

  def test
    request.body.rewind
    data = JSON.parse(request.body.read)
    bot = Telegram::Bot::Api.new(ENV["TELEGRAM_BOT_API_TOKEN"])
    message = Telegram::Bot::Types::Update.new(data).message
    puts "=============================================================================="
    case message
    when Telegram::Bot::Types::CallbackQuery
      puts message.data
      puts message.message.text
      bot.send_message(chat_id: message.from.id, text: "Serie #{message.data} iniciada")
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
        pp "/Start"
        pp answers
        pp message.chat.id
        # bot.send_message(chat_id: message.chat.id, text: "Bienvenido aqui puedes controlar el estado de las alertas del sistema :)", reply_markup: answers)
        @bot.send_message(chat_id: @message.chat.id, text: "Hi, #{@message.from.first_name}, nice to see you")
      when "/status"
        pp "/Status"
        pp message.chat.id
        bot.send_message(chat_id: message.chat.id, text: "La Alerta esta #{AlertsController.alertStatus} y se esta ejecutando la secuencia: #{AlertsController.actualSerie}")
      when "/toggleAlert"
        pp "/toggleAlert"
        pp AlertsController.alertstatus
        AlertsController.alertstatus = AlertsController.alertstatus
        pp AlertsController.alertstatus
      when "/getSerie"
        pp "/getSerie"
        pp message.chat.id

        bot.send_message(chat_id: message.chat.id, text: "La serie actual es: #{AlertsController.actualSerie}")
        #implementar un gif de la serie

      when "/setSerie"
        pp "/setSerie"
        kb = []
        Alert.all.each do
          |alert|
          kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: alert.titulo, callback_data: alert.id))
        end
        answers = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        puts answers
        pp message.chat.id
        bot.send_message(chat_id: message.chat.id, text: "Series:", reply_markup: answers)
      when "/stop"
        pp "/stop"
        kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        puts kb
        pp message.chat.id
        pp message.from.username
        bot.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.username}", reply_markup: kb)
      else
        pp "N/A"
        pp message.chat.id
        pp message.from.username
        bot.send_message(chat_id: message.chat.id, text: "Lo siento #{message.from.username}, Comando no reconocido.")
      end
    end
  end
end
