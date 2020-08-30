class Event < ApplicationRecord
  belongs_to :alert, foreign_key: "alert_id"

  validates_presence_of :titulo
end
