class EventsController < ApplicationController
  @@DateToday = nil
  @@eventsToday
  @@Alerted_Events = Hash.new

  def self.getEvents
    puts Time.now
    hoy = Time.now
    @@eventsToday = Event.where(fecha: hoy.to_date)
    @@eventsToday.each do |event|
      eventTime = Time.parse(event.fecha.concat(" ", event.hora))
      diference = (eventTime - hoy) / 60
      puts "Faltan: #{(diference / 60).to_i} Horas y #{(diference % 60).to_i} Minutos para #{event.titulo}"
      if diference <= 10.0
        if EventsController.noticed(event.titulo) == nil
          puts "avisando..."
          TelegramBotsController.SendMessage("Pronto a suceder: ** #{event.titulo} ** \n #{event.cuerpo}", event.users_id)
          #telegram message "pronto a suceder: *#{event.titulo}*\n #{event.description}"
        end
        if diference <= 1.0 && @@Alerted_Events[event.titulo] == false && diference > -5.0
          AlertsController.togglealert(true)
          AlertsController.set_serie(event.alert_id)
          TelegramBotsController.SendMessage("Pronto a suceder: ** #{event.titulo} ** \n #{event.cuerpo}", event.users_id)     
          pp Update.new(
            titulo: "Evento #{event.titulo} activado.",
            cuerpo: "#{event.cuerpo}.",
            clase: "evento",
          )
          @@Alerted_Events[event.titulo] == true
          EventsController.updateDate(event, event.repeticion)
        end
        puts "La Alerta esta #{AlertsController.alertStatus} y se esta ejecutando la secuencia: #{AlertsController.actualSerie}"
        pp event
      end
    end
    puts Time.now
  end

  def self.noticed(title)
    value = @@Alerted_Events.assoc(title)
    if value == nil
      @@Alerted_Events[title] = false
    end
    value
  end

  def self.eventNow
    today = Time.now
    @@DateToday = today.to_date
    puts today.strftime("%H:%M")
  end

  def self.today
    if @@DateToday == nil
      EventsController.eventNow
    end
    pp @@DateToday
    @@DateToday
  end

  def newEvent
    usuarios = []
    if params[:fecha] == ""
      render js: "alert('por favor ingresa una fecha');"
    elsif params[:hora] == ""
      render js: "alert('Por favor ingresa una hora');"
    else
      case params[:notificar]
      when "Todos"
        usuarios.push -1
      when "Espec"
        params[:users].each do |user|
          pp User.where(id: user)
          usuarios.push User.where(id: user)[0].chat_id
        end
      end
      pp Event.create(
        titulo: params[:titulo],
        cuerpo: params[:cuerpo],
        fecha: params[:fecha],
        hora: params[:hora],
        alert_id: params[:alerta],
        repeticion: params[:repeticion],
        users_id: usuarios,
      )
    end
    redirect_to home_path
  end

  def self.updateDate(event, option)
    case option
    when 1
      event.update(fecha: (Time.parse(event.fecha) + 1.day).to_date)
    when 2
      event.update(fecha: (Time.parse(event.fecha) + 2.day).to_date)
    when 3
      if Time.parse(event.fecha).friday?
        event.update(fecha: (Time.parse(event.fecha) + 3.day).to_date)
      else
        event.update(fecha: (Time.parse(event.fecha) + 1.day).to_date)
      end
    when 4
      event.update(fecha: (Time.parse(event.fecha) + 1.week).to_date)
    when 5
      event.update(fecha: (Time.parse(event.fecha) + 2.week).to_date)
    when 6
      event.update(fecha: (Time.parse(event.fecha) + 1.month).to_date)
    when 7
      event.update(fecha: (Time.parse(event.fecha) + 2.month).to_date)
      # else
    end
  end

  def self.encodeRepeticion(input)
    output = 0
    case input
    when "Diario"
      output = 1
    when "2 dias"
      output = 2
    when "Habiles"
      output = 3
    when "Semanal"
      output = 4
    when "Bisemanal"
      output = 5
    when "Mensual"
      output = 6
    when "Bimensual"
      output = 7
    end
    output
  end
end
