require 'protected_attributes'
require_relative 'user'

module MeteorTracker
  class Event < ActiveRecord::Base
    DIRS = %w(s sw w nw n ne e se)
    
    validates :time, :ra, :dec, :dir, presence: true
    validates :dir, inclusion: DIRS
    validates :shower, presence: true, if: :shower_id?
    validates :user, presence: true
    
    attr_accessible :time, :ra, :dec, :dir, :len, :mag, :vel, :shower_id
    
    belongs_to :shower
    belongs_to :user
  end
end
