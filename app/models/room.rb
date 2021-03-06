class Room < ActiveRecord::Base
  belongs_to :event
  belongs_to :venue
  has_many :submissions

  default_scope -> { order("#{table_name}.order ASC") }
end
