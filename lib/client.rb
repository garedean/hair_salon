class Client
  attr_reader(:id, :first_name, :last_name, :full_name)

  define_method(:initialize) do |attributes|
    @id         = attributes.fetch(:id)
    @first_name = attributes.fetch(:first_name)
    @last_name  = attributes.fetch(:last_name)
    @full_name  = "#{first_name} #{last_name}"
  end

  define_method(:==) do |other_client|
    @first_name == other_client.first_name &&
    @last_name  == other_client.last_name
  end

  define_method(:save) do
    id = DB.exec("INSERT INTO clients (first_name, last_name, stylist_id) VALUES ('#{@first_name}', '#{@last_name}', NULL) RETURNING id;")
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

  define_method(:assign_stylist) do |id|
    DB.exec("UPDATE clients SET stylist_id=#{id} WHERE id=#{@id};")
  end

  define_method(:unassign_stylist) do
    DB.exec("UPDATE clients SET stylist_id=NULL WHERE id=#{@id};")
  end

  define_method(:stylist) do
    returned_stylist = DB.exec("SELECT stylist_id FROM clients WHERE id=#{@id};")
    stylist_id = returned_stylist.first["stylist_id"]

    if stylist_id
      Stylist.find(id: stylist_id.to_i).first
    else
      nil
    end
  end

  define_singleton_method(:find) do |options|
    target_id   = options.fetch(:id, nil)
    target_name = options.fetch(:name, nil)

    clients = []

    # Not expecting user to search by id and name
    if target_id
      returned_client = DB.exec("SELECT * FROM clients WHERE id=#{target_id};").first
      id         = returned_client.fetch("id").to_i
      first_name = returned_client.fetch("first_name")
      last_name  = returned_client.fetch("last_name")
      clients << Client.new(id: id, first_name: first_name, last_name: last_name)
    end

    if target_name
      clients = []
      returned_clients = DB.exec("SELECT * FROM clients WHERE first_name LIKE '%#{target_name}%';")
      returned_clients.each do |client|
        id         = returned_client.fetch("id").to_i
        first_name = returned_client.fetch("first_name")
        last_name  = returned_client.fetch("last_name")
        clients << Client.new(id: id, first_name: first_name, last_name: last_name)
      end
    end
    clients
  end

  # Returns an array of client objects
  define_singleton_method(:all) do
    clients = []
    returned_clients = DB.exec("SELECT * FROM clients")
    returned_clients.each do |client|
      id         = client.fetch("id").to_i
      first_name = client.fetch("first_name")
      last_name  = client.fetch("last_name")
      clients << Client.new(id: id, first_name: first_name, last_name: last_name)
    end
    clients
  end

  define_singleton_method(:clear) do
    DB.exec("DELETE FROM clients")
  end
end
