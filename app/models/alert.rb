class Alert < ApplicationRecord
  has_many :events, dependent: :destroy
  validates_presence_of :titulo, :secuencia

  def new
    @alert = Alert.new
  end

  def self.day
    puts "HELLO FROM WHENEVER"
  end
  def self.initial
    puts "===== INICIANDO ====="
  end
end
