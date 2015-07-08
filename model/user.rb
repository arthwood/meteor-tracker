require 'bcrypt'
require_relative 'event'

module MeteorTracker
  class User < ActiveRecord::Base
    include BCrypt
    
    validates :login, :password_hash, :role, presence: true
    validates :login, uniqueness: true
    validates :role, inclusion: %w(user admin)
    
    has_many :events
    
    def password
      @password ||= Password.new(password_hash)
    end

    def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
    end
    
    def self.authenticate(login, password, role = nil)
      user = where(login: login).first
      
      user.present? && user.password == password && (role.nil? || user.role == role.to_s) ? user : nil
    end
  end
end
