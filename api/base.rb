require 'grape'
require_relative 'reports'
require_relative 'showers'

module MeteorTracker::Api
  class Base < Grape::API
    mount Reports
    mount Showers
  end
end
