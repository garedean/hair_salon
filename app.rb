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
  @stylists = Stylist.all
  erb(:stylists)
end

post('/stylists') do
  first_name = params.fetch("first_name").capitalize
  last_name  = params.fetch("last_name").capitalize
  stylist = Stylist.new(id: nil, first_name: first_name, last_name: last_name).save()
  redirect to("/stylists/#{stylist.id}")
end

get('/stylists/new') do
  erb(:stylist_form)
end

get('/stylists/:id') do
  id = params.fetch("id").to_i
  @stylist = Stylist.find(id: id).first
  erb(:stylist)
end

patch('/stylists') do
  id         = params.fetch("id").to_i
  first_name = params.fetch("first_name")
  last_name  = params.fetch("last_name")
  stylist    = Stylist.find(id: id).first
  stylist.update(first_name: first_name, last_name: last_name)
  redirect back
end

delete('/stylists') do
  id = params.fetch("id").to_i
  stylist = Stylist.find(id: id).first
  stylist.delete
  redirect to('/stylists')
end

get('/clients') do
  @clients = Client.all
  erb(:clients)
end

get('/clients/new') do
  erb(:client_form)
end

get('/stylists/:id') do
  id = params.fetch("id").to_i
  @client = Client.find(id: id).first
  erb(:client)
end

get('/clients/:id') do
  id = params.fetch("id").to_i
  @client = Client.find(id: id).first
  @stylists = Stylist.all

  erb(:client)
end

post('/clients') do
  first_name = params.fetch("first_name").capitalize
  last_name  = params.fetch("last_name").capitalize
  client = Client.new(id: nil, client_id: nil, first_name: first_name, last_name: last_name).save()
  redirect to("/clients/#{client.id}")
end

patch('/clients') do
  client_id  = params.fetch("id").to_i
  first_name = params.fetch("first_name")
  last_name  = params.fetch("last_name")
  stylist_id = params.fetch("stylist_id", nil).to_i

  client     = Client.find(id: client_id).first
  client.update(first_name: first_name, last_name: last_name)

  if stylist_id > 0
    client.assign_stylist(stylist_id.to_i)
  else
    client.unassign_stylist
  end
  redirect back
end

delete('/clients') do
  id = params.fetch("id").to_i
  client = Client.find(id: id).first
  client.delete
  redirect to('/clients')
end
