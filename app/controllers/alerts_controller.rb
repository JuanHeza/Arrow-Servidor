class AlertsController < ApplicationController
  @@actual = 1
  @@alertstatus = false
  @@colores = [
    "#000000", # BLACK
    "#000080", # NAVY BLUE
    "#0000FF", # BLUE
    "#0080FF", # AZURE
    "#008080", # TEAL
    "#808008", # GRAY
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

  def home
    # print "actual:" + @@actual + "\n"
    @data = Alert.all
    @serie = Alert.find(@@actual)
    @colores = @@colores
    if @@alertstatus
      @status = "Encendido"
    else
      @status = "Apagado"
    end
  end

  def alertToggle
    @@alertstatus = !@@alertstatus
    redirect_to home_path
  end

  def alertStatus
    if @@alertstatus
      render json: { status: "HIGH" }.to_json, status: :ok
    else
      render json: { status: "LOW" }.to_json, status: :ok
    end
    # redirect_to home_path
  end

  def serieSet
    @@actual = params[:id]
    redirect_to home_path
  end

  def serieStatus
    data = Alert.all
    actual = Alert.find(@@actual)
    # pp data
    # @nombre = "green"
    # @serie = [
    #   ["red", "white", "blue", "green"],
    #   ["green", "red", "white", "blue"],
    #   ["blue", "green", "red", "white"],
    #   ["white", "blue", "green", "red"],
    # ]
    render json: actual.to_json, status: :ok
    # render json: { titulo: "test", serie: @serie }.to_json, status: :ok
    # redirect_to home_path
  end
end
