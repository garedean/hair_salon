require('rspec')
require('client')
require('stylist')
require('pg')
require('pry')

DB = PG.connect(dbname: 'hair_salon_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM clients;")
    DB.exec("DELETE FROM stylists;")
  end
end

# Global method that initializes and saves a stylist to the 'stylists' db
define_method(:add_stylist) do |first_name, last_name|
  Stylist.new(id: nil, first_name: first_name, last_name: last_name).save()
end

# Global method that initializes and saves a client to the 'stylists' db
define_method(:add_client) do |first_name, last_name|
  Client.new(id: nil, first_name: first_name, last_name: last_name).save()
end
