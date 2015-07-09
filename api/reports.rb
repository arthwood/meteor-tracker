require 'grape'
require_relative '../model/event'
require_relative '../model/user'

module MeteorTracker
  class Api::Reports < Grape::API
    version 'v1', using: :header, vendor: 'meteor_tracker'
    format :json
    prefix :api
    
    helpers do
      def events_scope
        @current_user.admin? ? Model::Event : @current_user.events
      end
    end
    
    resource :reports do
      http_basic do |login, password|
        @current_user = Model::User.authenticate(login, password)
      end
      
      desc 'Creates meteor event'
      params do
        requires :time, type: String, desc: 'Time'
        requires :coords, type: Hash do
          requires :ra, type: String, desc: 'Right ascention'
          requires :dec, type: String, desc: 'Declination'
        end
        requires :dir, type: String, desc: 'Direction', values: Model::Event::DIRS
        optional :len, type: Integer, desc: 'Arc length'
        optional :mag, type: Float, desc: 'Brightness'
        optional :vel, type: Float, desc: 'Velocity'
        optional :shower_id, type: Integer, desc: 'Shower ID'
      end
      post do
        data = declared(params)
        
        resource = @current_user.events.create(data.merge(data.delete(:coords)))
        
        if resource.valid?
          resource.id
        else
          error! resource.errors.as_json, 400
        end
      end
      
      desc 'Updates meteor event'
      params do
        optional :time, type: String, desc: 'Time'
        optional :coords, type: Hash, default: {} do
          optional :ra, type: String, desc: 'Right ascention'
          optional :dec, type: String, desc: 'Declination'
        end
        optional :dir, type: String, desc: 'Direction', values: Model::Event::DIRS
        optional :len, type: Integer, desc: 'Arc length'
        optional :mag, type: Float, desc: 'Brightness'
        optional :vel, type: Float, desc: 'Velocity'
        optional :shower_id, type: Integer, desc: 'Shower ID'
      end
      put ':id', requirements: { id: /[0-9]*/ } do
        begin
          data = declared(params, include_missing: false)
          data = data.merge(data.delete(:coords))
          resource = events_scope.find(params[:id])
          
          unless resource.update(data)
            error! resource.errors.as_json, 400
          end
        rescue ActiveRecord::RecordNotFound
          error! nil, 404
        end
      end
      
      desc 'Deletes meteor event'
      delete ':id', requirements: { id: /[0-9]*/ } do
        begin
          resource = events_scope.find(params[:id])
          
          resource.destroy
        rescue ActiveRecord::RecordNotFound
          error! nil, 404
        end
      end
    end
  end
end
