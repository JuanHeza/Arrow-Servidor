class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token
  @@actual = 1
  @@alertstatus = false
  @@colores = [
    "#000000", # BLACK
    "#000080", # NAVY BLUE
    "#0000FF", # BLUE
    "#0080FF", # AZURE
    "#008080", # TEAL
    "#808080", # GRAY
    "#8080FF", # INDIGO
    "#8000FF", # VIOLET
    "#800080", # PURPLE
    "#800000", # MARRON
    "#FF0000", # RED
    "#FF0080", # PINK
    "#FF00FF", # MAGENTA
    "#FF8080", # PINK2
    "#FF80FF", # FUSCHIA
    "#FFFFFF", # WHITE
    "#FFFF80", # YELLOW2
    "#FFFF00", # YELLOW
    "#FF8000", # ORANGE
    "#808000", # GOLD
    "#80FF00", # LIME
    "#80FFFF", # AQUA
    "#80FF80", # MINT2
    "#00FFFF", # CYAN
    "#00FF80", # MINT
    "#00FF00", # GREEN
    "#008000", # AO
  ]
  @@custom

  def self.actualSerie
    Alert.find(@@actual).titulo
  end

  def self.set_serie(n)
    @@actual = n
  end

  def self.alertStatus
    @@alertstatus
  end

  def self.togglealert(*status)
    if status.size > 0
      @@alertstatus = status[0]
    else
      @@alertstatus = !@@alertstatus
    end
  end

  def home
    # print "actual:" + @@actual + "\n"
    @data = {}
    @data["alerts"] = Alert.all
    @data["updates"] = Update.order(created_at: :desc).last(10)
    if @@actual != 0
      @serie = Alert.find(@@actual)
    else
      @serie = @@custom
    end
    @colores = @@colores
    if @@alertstatus
      @status = "Encendido"
    else
      @status = "Apagado"
    end
    puts "Serie: " + @serie.titulo
    puts "Status: " + @status
  end

  def alertToggle
    @@alertstatus = !@@alertstatus
    if @@alertstatus
      @status = "Encendido"
    else
      @status = "Apagado"
    end
    pp update.create(
      titulo: "Via Web.",
      cuerpo: "La alarma se ha #{@status}.",
      clase: "web",
    )
    redirect_to home_path
  end

  def alertStatus
    if @@alertstatus
      render json: { status: "HIGH", serie: @@actual }.to_json, status: :ok
    else
      render json: { status: "LOW", serie: @@actual }.to_json, status: :ok
    end
    # redirect_to home_path
  end

  def serieSet
    @@actual = params[:id]

    pp update.create(
      titulo: "Via Web",
      cuerpo: "Se activo la serie #{Alert.find(@@actual).titulo}.",
      clase: "web",
    )
    redirect_to home_path
  end

  def serieStatus
    # data = Alert.all
    if @@actual != 0
      actual = Alert.find(@@actual)
    else
      actual = @@custom
    end
    render json: actual.to_json, status: :ok
  end

  def serieCustom
    data = ActiveSupport::JSON.decode(params[:_json])
    @@custom = Alert.new(
      id: 0,
      titulo: "Serie Personalizada",
      secuencia: AlertsController.decode(data["secuencia"]),
    )
    @@actual = 0
    pp @@custom
    pp @@colores[@@custom[:secuencia][0][0].to_i]
    redirect_to home_path
  end

  def self.decode(data)
    secuencia = []
    pp data
    for i in 0...data.length
      frame = []
      for j in 0...data[i].length
        for k in 0...@@colores.length
          if @@colores[k] == data[i][j]
            frame.push k
          end
        end
      end
      secuencia.push frame
    end
    return secuencia
  end

  def newSerie
    secuencia = []
    frame = []
    for i in 0...params[:pixel_1].length
      frame.push params[:pixel_1][i], params[:pixel_2][i], params[:pixel_3][i], params[:pixel_4][i]
      secuencia.push frame
      frame = []
    end

    if (Alert.where(titulo: params[:title]).count > 0)
      pp "Se Encontraron resultados: ", Alert.where(titulo: params[:title]), " || " + params[:title]
      render js: " alert('Ya existe una secuencia con ese titulo')"
    else
      puts "Nueva alerta"
      pp Alert.create(titulo: params[:title], secuencia: AlertsController.decode(secuencia))
      redirect_to home_path
    end
  end
end
