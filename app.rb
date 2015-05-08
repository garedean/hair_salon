require('sinatra')
require('sinatra/reloader')
require('./lib/client.rb')
require('./lib/stylist.rb')
require('pg')
require('pry')
also_reload('lib/**/*.rb')

DB = PG.connect(dbname: 'hair_salon')

get('/reset') do
  Client.clear()
  Stylist.clear()
  redirect to('/')
end

get('/') do
  @stylist_count = Stylist.all.size
  @client_count  = Client.all.size
  erb(:index)
end

get('/stylists') do
  target_name = params.fetch("name")

  @stylists = Stylist.find(name: target_name)
  erb(:stylists)
end

post('/stylists') do
  first_name = params.fetch("first_name")
  last_name  = params.fetch("last_name")
  stylist = Stylist.new(id: nil, first_name: first_name, last_name: last_name).save()
  redirect to("/stylists/#{stylist.id}")
end

get('/stylists/new') do
  erb(:stylist_form)
end

get('/stylists/:id') do
  id = params.fetch("id").to_i
  @stylist = Stylist.find(id)
  erb(:stylist)
end
