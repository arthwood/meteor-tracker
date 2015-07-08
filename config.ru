require 'active_record'
require_relative 'app'
require_relative 'api/base'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run MeteorTracker::Api::Base
