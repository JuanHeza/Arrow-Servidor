desc "Print reminder about eating more fruit."

task :bot do
  puts "Eat more apples!"
end

task :telegramwebhook do
require 'telegram/bot'
url = 'https://juanheza-arrow-alerts.herokuapp.com/telegram'
bot = Telegram::Bot::Api.new(ENV.fetch("TELEGRAM_BOT_TOKEN"))
puts bot.set_webhook(url: url)
end
