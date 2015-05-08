require('rspec')
require('book')
require('client')
require('stylist')
require('pg')
require('pry')

DB = PG.connect(dbname: 'hair_salon_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM client;")
    DB.exec("DELETE FROM stylist;")
  end
end
