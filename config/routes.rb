Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "alerts#home"

  ### AREA DE LINKS DEL MAESTRO & CONTROL ###
  post "/", to: "alerts#update", as: "home"
  get "/Alert", to: "alerts#alertToggle", as: "alert"
  get "/Serie/:id", to: "alerts#serieSet", as: "serie"

  ### AREA DE LINKS DEL ESCLAVO & HARDWARE ###
  get "/Status/Alert", to: "alerts#alertStatus"
  get "/Status/Serie", to: "alerts#serieStatus"

  post "/telegram", to: "telegram_bots#test"
  # post "/webhooks/telegram_vbc43edbf1614a075954dvd4bfab34l1" => 'webhooks#callback'
  # post "/webhooks/telegram/#{ENV.fetch("TELEGRAM_BOT_TOKEN")}", to:'telegram_bot#create'
end
