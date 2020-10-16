desc "Print reminder about eating more fruit."

task :bot do
  puts "Eat more apples!"
end

task :telegramwebhook do
  require "telegram/bot"
  url = "https://juanheza-arrow-alerts.herokuapp.com/telegram"
  bot = Telegram::Bot::Api.new(ENV.fetch("TELEGRAM_BOT_TOKEN"))
  puts bot.set_webhook(url: url)
end

desc "task de prueba"
task set_User: :environment do
  # pp User.new(chat_id: "33973084", username: "JuanHeza", first_name: "Heza", last_name: "Juan")
  pp Event.all
end

desc "Get today events"
task get_Events: :environment do
  EventsController.getEvents
end

task new_user: :environment do
  UsersController.new_User(33973084, "JuanHeza", "Juan", "Heza")
  UsersController.new_User(000, "Jazlin1", "Citlatlee", "Quiroz")
end

task telegram_test: :environment do
  TelegramBotsController.SendMessage("Pronto a suceder: ** {event.titulo} ** \n {event.cuerpo}", [-1])
end

task get_database: :environment do
  puts Time.now
  pp "Usuarios: #{User.all.length}"
  pp "Alertas: #{Alert.all.length}"
  pp "Eventos: #{Event.all.length}"
  pp "Updates: #{Update.all.length}"
  pp Event.last.created_at.localtime
  puts Time.now
end

task set_event: :environment do
  TelegramBotsController.Event({ "update_id" => 23788848, "message" => { "message_id" => 178, "from" => { "id" => 33973084, "is_bot" => false, "first_name" => "Juan", "last_name" => "Heza", "username" => "JuanHeza", "language_code" => "es" }, "chat" => { "id" => 33973084, "first_name" => "Juan", "last_name" => "Heza", "username" => "JuanHeza", "type" => "private" }, "date" => 1601675344, "text" => "/start hola |azul | 00:00 | 23-08-2222 | Azul | diario | juan heza", "entities" => [{ "offset" => 0, "length" => 6, "type" => "bot_command" }] }, "telegram_bot" => { "update_id" => 23788848, "message" => { "message_id" => 178, "from" => { "id" => 33973084, "is_bot" => false, "first_name" => "Juan", "last_name" => "Heza", "username" => "JuanHeza", "language_code" => "es" }, "chat" => { "id" => 33973084, "first_name" => "Juan", "last_name" => "Heza", "username" => "JuanHeza", "type" => "private" }, "date" => 1601675344, "text" => "/start hola |azul | 00:00 | 23-08-2222 | Azul | juan heza", "entities" => [{ "offset" => 0, "length" => 6, "type" => "bot_command" }] } } })
end

task message: :environment do
  text = "\tAlertas:"
  Alert.all.each do |alerta|
    text.concat("\n", alerta.titulo)
  end
  text.concat("\n\n\tRepeticion:")
  ["Diario", "2 dias", "Habiles", "Semanal", "Bisemanal", "Mensual", "Bimensual"].each do |repet|
    text.concat("\n", repet)
  end
  text.concat("\n\n\tUsuarios:")
  User.all.each do |user|
    text.concat("\n", user)
  end
  puts text
end

# rails db:drop db:setup db:migrate db:seed || db:rreset db:seed
