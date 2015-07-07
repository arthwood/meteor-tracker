require 'active_record'
require 'logger'

ActiveRecord::Base.logger = Logger.new('debug.log')
configuration = YAML::load(IO.read('db/config.yml'))
mode = ENV['mode'] == 'test' ? 'test' : 'development'

ActiveRecord::Base.establish_connection(configuration[mode])

module MeteorTracker
end
