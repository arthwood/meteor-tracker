module MeteorTracker
  class Shower < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
    
    has_many :events
  end
end
