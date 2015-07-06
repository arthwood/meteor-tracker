require 'bcrypt'

module MeteorTracker
  class User < ActiveRecord::Base
    include BCrypt
    
    validates :login, :password_hash, :role, presence: true
    
    has_many :events
    
    def password
      @password ||= Password.new(password_hash)
    end

    def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
    end
    
    def self.authenticate(login, password)
      user = where(login: login).first
      
      user.present? && user.password == password ? user : nil
    end
  end
end
