class Client
  attr_reader(:id, :client_id, :first_name, :last_name, :full_name)

  define_method(:initialize) do |attributes|
    @id         = attributes.fetch(:id)
    @client_id = attributes.fetch(:client_id)
    @first_name = attributes.fetch(:first_name)
    @last_name  = attributes.fetch(:last_name)
    @full_name  = "#{first_name} #{last_name}"
  end

  define_method(:==) do |other_client|
    @first_name == other_client.first_name &&
    @last_name  == other_client.last_name
  end

  define_method(:save) do
    id = DB.exec("INSERT INTO clients (first_name, last_name) VALUES ('#{@first_name}', '#{@last_name}') RETURNING id;")
    @id = id.first.fetch("id").to_i
    self
  end

  define_method(:delete) do
    DB.exec("DELETE FROM clients WHERE id=#{@id};")
  end

  define_method(:update) do |options|
    first_name = options.fetch(:first_name, nil)
    last_name  = options.fetch(:last_name, nil)

    if first_name
      DB.exec("UPDATE clients SET first_name='#{first_name}' WHERE id=#{@id};")
      @first_name = first_name
    end

    if last_name
      DB.exec("UPDATE clients SET last_name='#{last_name}' WHERE id=#{@id};")
      @last_name = last_name
    end
  end

  # Returns a single client object
  define_singleton_method(:find) do |id|
    returned_client = DB.exec("SELECT * FROM clients WHERE id=#{id};").first
    first_name = returned_client.fetch("first_name")
    last_name  = returned_client.fetch("last_name")
    client.new(id: id, first_name: first_name, last_name: last_name).save()
  end

  # Returns an array of client objects
  define_singleton_method(:all) do
    clients = []
    returned_clients = DB.exec("SELECT * FROM clients")
    returned_clients.each do |client|
      id         = client.fetch("id").to_i
      stylist_id = client.fetch("stylist_id").to_i
      first_name = client.fetch("first_name")
      last_name  = client.fetch("last_name")
      clients << client.new(id: id, first_name: first_name, last_name: last_name)
    end
    clients
  end

  define_singleton_method(:clear) do
    DB.exec("DELETE FROM clients")
  end
end
