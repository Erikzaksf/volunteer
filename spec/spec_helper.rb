
# require "volunteer"
require "project"
require "rspec"
require "pry"
require "pg"

DB = PG.connect({:dbname => 'volunteers_tracker_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec('DELETE FROM volunteers *;')
    DB.exec('DELETE FROM projects *;')
  end
end
