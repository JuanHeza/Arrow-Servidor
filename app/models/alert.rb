class Alert < ApplicationRecord
        has_many :events, dependent: :destroy
        validates_presence_of :titulo, :secuencia
end
