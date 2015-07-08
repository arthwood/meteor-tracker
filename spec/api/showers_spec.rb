require 'rack/test'

require_relative '../spec_helper'
require_relative '../../api/showers'

module MeteorTracker
  describe Api::Showers do
    include Rack::Test::Methods
  
    def app
      described_class
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
    
    describe 'POST showers' do
      context 'as guest' do
        it 'should fail' do
          post '/api/showers'
          
          expect(last_response.status).to eq(401)
        end
      end
      
      context 'as user' do
        let!(:user) { create(:user) }
        let(:env) do
          {HTTP_AUTHORIZATION: simple_auth(user.login, attributes_for(:user)[:user])}.as_json
        end
        
        it 'should fail' do
          post '/api/showers', nil, env
          
          expect(last_response.status).to eq(401)
        end
      end
      
      context 'as admin' do
        let!(:admin) { create(:admin) }
        let(:env) do
          {HTTP_AUTHORIZATION: simple_auth(admin.login, attributes_for(:admin)[:password])}.as_json
        end
        
        context 'invalid data' do
          it 'should fail' do
            post '/api/showers', nil, env
            
            expect(last_response.status).to eq(400)
          end
        end
        
        context 'valid data' do
          let(:data) do
            {
              name: 'Unicornids'
            }
          end
          
          it 'should create shower entry' do
            post '/api/showers', data, env
            
            expect(last_response.status).to eq(201)
            expect(Model::Shower.count).to eq(1)
            expect(Model::Shower.first.name).to eq(data[:name])
          end
        end
      end
    end
  end
end
