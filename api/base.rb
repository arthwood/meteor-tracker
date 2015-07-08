require 'grape'
require_relative '../model/event'
require_relative '../model/shower'
require_relative '../model/user'

module MeteorTracker
  class API < Grape::API
    version 'v1', using: :header, vendor: 'meteor_tracker'
    format :json
    prefix :api
    
    resource :showers do
      get do
        Shower.all
      end
    end
    
    resource :showers do
      http_basic do |login, password|
        @current_user = User.authenticate(login, password, :admin)
      end
      
      desc 'Creates new meteor shower definition'
      params do
        requires :name, type: String, desc: 'Name'
      end
      post do
        data = declared(params)
        
        resource = Shower.create(data)
        
        resource.valid? ? resource.id : nil
      end
    end
    
    resource :reports do
      http_basic do |login, password|
        @current_user = User.authenticate(login, password)
      end
      
      desc 'Creates new meteor event report'
      params do
        requires :time, type: String, desc: 'Time'
        requires :coords, type: Hash do
          requires :ra, type: String, desc: 'Right ascention'
          requires :dec, type: String, desc: 'Declination'
        end
        requires :dir, type: String, desc: 'Direction', values: Event::DIRS
        optional :len, type: Integer, desc: 'Arc length'
        optional :mag, type: Float, desc: 'Brightness'
        optional :vel, type: Float, desc: 'Velocity'
        optional :shower_id, type: Integer, desc: 'Shower ID'
      end
      post do
        data = declared(params)
        resource = @current_user.events.create(data.merge(data.delete(:coords)))
        
        resource.valid? ? resource.id : nil
      end
    end
  end
end
