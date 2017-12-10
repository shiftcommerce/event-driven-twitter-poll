require 'dotenv/load' unless 'production' == ENV['RACK_ENV']

$stdout.puts 'Loading ActiveRecord'

require 'active_record'
require 'yaml'
require 'erb'

$stdout.puts 'Configuring ActiveRecord'

path = File.join(File.dirname(__FILE__), '../db/config.yml')
db_config = YAML::load(ERB.new(File.read(path)).result).fetch(ENV.fetch('RACK_ENV', 'development'))
ActiveRecord::Base.establish_connection(db_config)

$stdout.puts 'Configured ActiveRecord'
