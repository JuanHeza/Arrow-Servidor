class AlertsController < ApplicationController
  @@actual = 1
  @@alertstatus = false

  def home
    # print "actual:" + @@actual + "\n"
    @data = Alert.all
    @titulo = Alert.find(@@actual).titulo
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
      @status = "Encendido"
    else
      @status = "Apagado"
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
