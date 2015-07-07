require 'rack/test'
require 'action_controller/metal/http_authentication'
require 'active_support/values/time_zone'

require_relative '../spec_helper'
require_relative '../../api/base'

describe MeteorTracker::API do
  include Rack::Test::Methods

  def app
    described_class
  end
  
  def simple_auth(user, pass)
    ActionController::HttpAuthentication::Basic.encode_credentials(user, pass)
  end

  describe 'GET showers' do
    let!(:showers) do
      [
        create(:shower, name: 'perseids'),
        create(:shower, name: 'draconids')
      ]
    end
    
    it 'returns showers list' do
      get '/api/showers'
      
      expect(last_response.status).to eq(200)
      
      expect(JSON.parse(last_response.body)).to include(
        {id: showers.first.id, name: showers.first.name}.as_json
      )
    end
  end
  
  describe 'POST report' do
    context 'unauthorized' do
      it 'should fail' do
        post '/api/reports'
        
        expect(last_response.status).to eq(401)
      end
    end
    
    context 'autorized' do
      let!(:user) { create(:user) }
      let(:env) do
        {HTTP_AUTHORIZATION: simple_auth(user.login, 'asdf1234')}.as_json
      end
      
      context 'invalid data' do
        it 'should fail' do
          post '/api/reports', nil, env
          
          expect(last_response.status).to eq(400)
        end
      end
      
      context 'valid data' do
        let(:data) do
          {
            time: '2015-06-04 21:11',
            coords: {
              ra: '14:13.32',
              dec: '27'
            },
            dir: 'sw'
          }
        end
        
        it 'should create event' do
          post '/api/reports', data, env
          
          time = Time.use_zone(ActiveSupport::TimeZone.new('UTC')) do
            Time.zone.parse(data[:time])
          end

          expect(last_response.status).to eq(201)
          expect(MeteorTracker::Event.count).to eq(1)
          expect(MeteorTracker::Event.first.time).to eq(time)
        end
      end
    end
  end
end
