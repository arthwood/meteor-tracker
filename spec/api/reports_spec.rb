require 'active_support/values/time_zone'
require 'rack/test'

require_relative '../spec_helper'
require_relative '../../api/reports'

module MeteorTracker
  describe Api::Reports do
    include Rack::Test::Methods
  
    def app
      described_class
    end
    
    def env_for(user, factory)
      {HTTP_AUTHORIZATION: simple_auth(user.login, attributes_for(factory)[:password])}.as_json
    end
    
    describe 'POST report' do
      context 'as guest' do
        it 'should fail' do
          post '/api/reports'
          
          expect(last_response.status).to eq(401)
        end
      end
      
      context 'as user' do
        context 'no data' do
          it 'should fail' do
            post '/api/reports', nil, env_for(create(:user), :user)
   
            expect(last_response.status).to eq(400)
          end
        end
        
        context 'invalid data' do
          let(:data) do
            {
              time: '2015-06-04 21:11',
              coords: {
                ra: '14:13.32',
                dec: '27'
              },
              dir: 'sw',
              shower_id: '99'
            }
          end
          
          it 'should fail' do
            post '/api/reports', data, env_for(create(:user), :user)
   
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
          
          it 'should succeed' do
            post '/api/reports', data, env_for(create(:user), :user)
            
            time = Time.use_zone(ActiveSupport::TimeZone.new('UTC')) do
              Time.zone.parse(data[:time])
            end
  
            expect(last_response.status).to eq(201)
            expect(Model::Event.count).to eq(1)
            expect(Model::Event.first.time).to eq(time)
          end
        end
      end
    end
    
    describe 'PUT report' do
      let(:event) { create(:event) }
      
      context 'as guest' do
        it 'should fail' do
          put "/api/reports/#{event.id}"
          
          expect(last_response.status).to eq(401)
        end
      end
      
      context 'as user' do
        context 'not an owner' do
          context 'other user' do
            let(:user) { create(:user, login: 'other user') }
            
            it 'should fail' do
              put "/api/reports/#{event.id}", nil, env_for(user, :user)
              
              expect(last_response.status).to eq(404)
            end
          end
          
          context 'admin' do
            let(:user) { create(:admin) }
            
            it 'should succeed' do
              put "/api/reports/#{event.id}", nil, env_for(user, :admin)
              
              expect(last_response.status).to eq(200)
            end
          end
        end
        
        context 'an owner' do
          let(:user) { event.user }
          
          context 'invalid data' do
            it 'should fail' do
              put "/api/reports/#{event.id}", {shower_id: 99}, env_for(user, :user)
     
              expect(last_response.status).to eq(400)
            end
          end
          
          context 'valid' do
            let(:shower) { create(:shower, name: 'unicornids') }
            
            it 'should succeed' do
              put "/api/reports/#{event.id}", {shower_id: shower.id}, env_for(user, :user)
     
              expect(last_response.status).to eq(200)
            end
          end
        end
      end
    end
    
    describe 'DELETE report' do
      let!(:event) { create(:event) }
      
      context 'as guest' do
        it 'should fail' do
          delete "/api/reports/#{event.id}"
          
          expect(last_response.status).to eq(401)
        end
      end
      
      context 'as user' do
        context 'not an owner' do
          context 'other user' do
            let(:user) { create(:user, login: 'other user') }

            it 'should fail' do
              delete "/api/reports/#{event.id}", nil, env_for(user, :user)

              expect(last_response.status).to eq(404)
            end
          end
          
          context 'admin' do
            let(:user) { create(:admin) }
            
            it 'should succeed' do
              delete "/api/reports/#{event.id}", nil, env_for(user, :admin)
              
              expect(last_response.status).to eq(200)
            end
          end
        end
        
        context 'an owner' do
          let(:user) { event.user }
          
          it 'should succeed' do
            delete "/api/reports/#{event.id}", nil, env_for(user, :user)
   
            expect(last_response.status).to eq(200)
          end
        end
      end
    end
  end
end
