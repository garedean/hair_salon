require('sinatra')
require('sinatra/reloader')
require('./lib/client.rb')
require('./lib/stylist.rb')
require('pg')
require('pry')
also_reload('lib/**/*.rb')

DB = PG.connect(dbname: 'hair_salon')

get('/') do
  erb(:index)
end

get('/stylists') do
  erb(:stylists)
end

get('/stylists/new') do
  erb(:stylists_new)
end
