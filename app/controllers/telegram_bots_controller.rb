require "telegram/bot"

class TelegramBotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  Comands = ["/start", "/status", "/toggleAlert", "/getSerie", "/setSerie", "/stop"]
  # test_series = ["Basico", "Rojo", "Blanco", "Azul", "Verde", "Friends"]

  def test
    request.body.rewind
    data = JSON.parse(request.body.read)
    bot = Telegram::Bot::Api.new(ENV["TELEGRAM_BOT_API_TOKEN"])
    Telegram::Bot::Types::Update.new(data).message != nil ? message = Telegram::Bot::Types::Update.new(data).message : message = Telegram::Bot::Types::Update.new(data).callback_query
    puts "=============================================================================="
    case message
    when Telegram::Bot::Types::CallbackQuery
      serie = ""
      message.message.reply_markup.inline_keyboard.each do
        |inline|
        if inline[0]["callback_data"] == message.data
          serie = inline[0]["text"]
          break
        end
      end
      bot.send_message(chat_id: message.from.id, text: "Serie #{serie} iniciada")
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
        bot.send_message(chat_id: message.chat.id, text: "Bienvenido aqui puedes controlar el estado de las alertas del sistema :)", reply_markup: answers)
      when "/status"
        pp "/Status"
        pp message.chat.id
        alarma = ""
        if AlertsController.alertStatus
          alarma = "Encendida"
        else
          alarma = "Apagada"
        end
        bot.send_message(chat_id: message.chat.id, text: "La Alerta esta #{alarma} y se esta ejecutando la secuencia: #{AlertsController.actualSerie}")
      when "/toggleAlert"
        pp "/toggleAlert"
        pp AlertsController.alertStatus
        AlertsController.togglealert
        pp AlertsController.alertStatus
        alarma = ""
        if AlertsController.alertStatus
          alarma = "Encendida"
        else
          alarma = "Apagada"
        end
        bot.send_message(chat_id: message.from.id, text: "La alarma esta #{alarma}")
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
    else
      bot.send_message(chat_id: message.chat.id, text: "ERROR NO IDENTIFICADO")
    end
  end
end
