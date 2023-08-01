require 'rest-client'
require 'json'

require 'sabotage'
require 'sabotage/async'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'
end
