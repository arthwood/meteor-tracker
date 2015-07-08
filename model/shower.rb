module MeteorTracker
  class Shower < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
    
    attr_accessible :name
    
    has_many :events
  end
end
