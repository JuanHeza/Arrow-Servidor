class AlertsController < ApplicationController
  @@actual = "Stand"
  @@alertstatus = false

  def home
    print "actual:" + @@actual + "\n"
    @titulo = @@actual
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
    @nombre = 'green'
    @serie = [
      ['red','white','blue','green'],
      ['green','red','white','blue'],
      ['blue','green','red','white'],
      ['white','blue','green','red']
    ]
    render json: { titulo: 'test', serie: @serie}.to_json, status: :ok
    # redirect_to home_path
  end
end
