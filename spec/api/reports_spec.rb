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
  
    describe 'POST report' do
      context 'as guest' do
        it 'should fail' do
          post '/api/reports'
          
          expect(last_response.status).to eq(401)
        end
      end
      
      context 'as user' do
        let!(:user) { create(:user) }
        let(:env) do
          {HTTP_AUTHORIZATION: simple_auth(user.login, attributes_for(:user)[:password])}.as_json
        end
        
        context 'no data' do
          it 'should fail' do
            post '/api/reports', nil, env
   
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
            post '/api/reports', data, env
   
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
            expect(Model::Event.count).to eq(1)
            expect(Model::Event.first.time).to eq(time)
          end
        end
      end
    end
  end
end
