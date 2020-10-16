require "telegram/bot"

class TelegramBotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  Comands = ["/start", "/status", "/toggleAlert", "/getSerie", "/setSerie", "/newEvent", "/stop"]
  # test_series = ["Basico", "Rojo", "Blanco", "Azul", "Verde", "Friends"]

  def test
    request.body.rewind
    data = JSON.parse(request.body.read)
    bot = Telegram::Bot::Api.new(ENV["TELEGRAM_BOT_API_TOKEN"])
    Telegram::Bot::Types::Update.new(data).message != nil ? message = Telegram::Bot::Types::Update.new(data).message : message = Telegram::Bot::Types::Update.new(data).callback_query
    puts "=============================================================================="
    user_registered = false
    User.where(chat_id: message.from.id) != nil ? user_registered = true : user_registered = false
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
      AlertsController.set_serie(message.data)
      pp Update.create(
        titulo: "Via Telegram",
        cuerpo: "#{message.from.first_name} activo la serie #{serie}.",
        clase: "telegram",
      )
      AlertsController.saveActual
      bot.send_message(chat_id: message.from.id, text: "Serie #{serie} iniciada")
    when Telegram::Bot::Types::Message
      case message.text[message.entities[0].offset..message.entities[0].length] #AQUI VA EL OFFSET <======================================
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
        UsersController.new_User(message.chat.id, message.from.username, message.from.first_name, message.from.last_name)
        pp answers
        pp message.chat.id
        bot.send_message(chat_id: message.chat.id, text: "Bienvenido aqui puedes controlar el estado de las alertas del sistema :)", reply_markup: answers)
      when "/status"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
          pp "/Status"
          pp message.chat.id
          alarma = ""
          if AlertsController.alertStatus
            alarma = "Encendida"
          else
            alarma = "Apagada"
          end
          bot.send_message(chat_id: message.chat.id, text: "La Alerta esta #{alarma} y se esta ejecutando la secuencia: #{AlertsController.actualSerie}")
        end
      when "/toggleAlert"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
          pp "/toggleAlert"
          pp AlertsController.alertStatus
          AlertsController.togglealert
          pp AlertsController.alertStatus
          alarma = ""
          if AlertsController.alertStatus
            alarma = "Encendio"
          else
            alarma = "Apago"
          end
          pp Update.create(
            titulo: "Via Telegram",
            cuerpo: "El usuario: #{message.from.first_name} #{alarma} la alarma.",
            clase: "telegram",
          )
          AlertsController.saveActual
          bot.send_message(chat_id: message.from.id, text: "La alarma se #{alarma}")
        end
      when "/getSerie"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
          pp "/getSerie"
          pp message.chat.id

          bot.send_message(chat_id: message.chat.id, text: "La serie actual es: #{AlertsController.actualSerie}")
          #implementar un gif de la serie
        end
      when "/setSerie"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
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
        end
      when "/stop"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
          pp "/stop"
          kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
          puts kb
          pp message.chat.id
          pp message.from.username
          user = User.where(chat_id: message.chat.id)[0]
          if user != nil
            user.destroy
          end
          bot.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.username}", reply_markup: kb)
        end
      when "/cancel"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
          pp "/cancel"
          answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: list, one_time_keyboard: true)
          puts answers
          bot.send_message(chat_id: message.chat.id, reply_markup: answers)
        end
      when "/newEvent"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
          kb = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: ["/createEvent", "/cancel"], one_time_keyboard: true)
          text = "\t**Alertas**:"
          Alert.all.each do |alerta|
            text.concat("\n", alerta.titulo)
          end
          text.concat("\n\n\t**Repeticion**:")
          ["Diario", "2 dias", "Habiles", "Semanal", "Bisemanal", "Mensual", "Bimensual"].each do |repet|
            text.concat("\n", repet)
          end
          text.concat("\n\n\t**Usuarios**: \n Todos")
          User.all.each do |user|
            text.concat("\n", user.first_name, "\t", user.last_name)
          end
          text.concat("\n\n **Formato** \n \/createEvent Titulo \& Descripcion \& 00:00 \& 23\-08\-2222 \& Serie \& Repeticion \& Usuario, usuario")
          pp text
          bot.send_message(chat_id: message.chat.id, text: text, reply_markup: kb, parse_mode: "MarkdownV2")
        end
      when "/createEvent"
        if !user_registered
          bot.send_message(chat_id: message.chat.id, text: "Usuario no regristrado, ingrese el comando **/start** para poder acceder a estas funciones")
        else
          values = message.text[message.entities[0].length...message.text.length].split("&", -1)
          if values.length == 7
            values.collect! do |value|
              value[0] == " " ? value = value[1..value.length].capitalize : value.capitalize
              value[value.length - 1] == " " ? value = value[0..value.length - 2].capitalize : value.capitalize
            end
            Event.create(
              titulo: values[0],
              cuerpo: values[1],
              hora: Time.parse(values[2]).strftime("%H:%M"),
              fecha: Time.parse(values[3]).to_date,
              alert_id: Alert.where(titulo: values[4])[0].id,
              repeticion: EventsController.encodeRepeticion(values[5]),
              users_id: UsersController.getUsers(values[6]),
            )
            bot.send_message(chat_id: message.chat.id, text: "Evento creado con exito")
          else
            bot.send_message(chat_id: message.chat.id, text: "Error, parametros faltantes")
          end
        end
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

  def self.SendMessage(text, users)
    chat_ids = []
    if users[0] == -1
      User.all.each do |user|
        chat_ids.push user.chat_id
      end
    else
      chat_ids = users
    end
    bot = Telegram::Bot::Api.new(ENV["TELEGRAM_BOT_API_TOKEN"])
    chat_ids.each do |message|
      bot.send_message(chat_id: message, text: text)
    end
  end

  def self.Event(data)
    a = Telegram::Bot::Types::Update.new(data)
    puts a.message.text[a.message.entities[0].offset..a.message.entities[0].length]
    values = a.message.text[a.message.entities[0].length...a.message.text.length].split("|", -1)
    if values.length == 7
      values.collect! do |value|
        value[0] == " " ? value = value[1..value.length].capitalize : value.capitalize
        value[value.length - 1] == " " ? value = value[0..value.length - 2].capitalize : value.capitalize
      end
      pp Event.create(
        titulo: values[0],
        cuerpo: values[1],
        hora: Time.parse(values[2]).strftime("%H:%M"),
        fecha: Time.parse(values[3]).to_date,
        alert_id: Alert.where(titulo: values[4])[0].id,
        repeticion: EventsController.encodeRepeticion(values[5]),
        users_id: UsersController.getUsers(values[6]),
      )
      pp "CORRECTO"
    else
      pp "ERROR valores faltantes"
    end
  end
end
