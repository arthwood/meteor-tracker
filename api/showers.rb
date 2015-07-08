require 'grape'
require_relative '../model/shower'
require_relative '../model/user'

module MeteorTracker
  class Api::Showers < Grape::API
    version 'v1', using: :header, vendor: 'meteor_tracker'
    format :json
    prefix :api
    
    resource :showers do
      get do
        Model::Shower.all
      end
    end
    
    resource :showers do
      http_basic do |login, password|
        @current_user = Model::User.authenticate(login, password, :admin)
      end
      
      desc 'Creates new meteor shower definition'
      params do
        requires :name, type: String, desc: 'Name'
      end
      post do
        data = declared(params)
        
        resource = Model::Shower.create(data)
        
        resource.valid? ? resource.id : nil
      end
    end
  end
end
