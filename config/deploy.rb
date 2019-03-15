lock '3.5.0'

load 'config/config_methods.rb'
load 'config/config_variables.rb'
load 'config/config_service.rb'

Dir.glob('config/recipes/install/*.rb').each { |r| load r }
Dir.glob('config/recipes/setup/*.rb').each { |r| load r }
