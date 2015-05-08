class Stylist
  attr_reader(:id, :first_name, :last_name, :full_name)

  define_method(:initialize) do |attributes|
    @id         = attributes.fetch(:id)
    @first_name = attributes.fetch(:first_name)
    @last_name  = attributes.fetch(:last_name)
    @full_name  = "#{first_name} #{last_name}"
  end

  define_method(:==) do |other_stylist|
    @first_name == other_stylist.first_name &&
    @last_name  == other_stylist.last_name
  end

  define_method(:save) do
    id = DB.exec("INSERT INTO stylists (first_name, last_name) VALUES ('#{@first_name}', '#{@last_name}') RETURNING id;")
    @id = id.first.fetch("id").to_i
    self
  end

  define_method(:delete) do
    DB.exec("DELETE FROM stylists WHERE id=#{@id};")
  end

  define_method(:update) do |options|
    first_name = options.fetch(:first_name, nil)
    last_name  = options.fetch(:last_name, nil)

    if first_name
      DB.exec("UPDATE stylists SET first_name='#{first_name}' WHERE id=#{@id};")
      @first_name = first_name
    end

    if last_name
      DB.exec("UPDATE stylists SET last_name='#{last_name}' WHERE id=#{@id};")
      @last_name = last_name
    end
  end

  # Returns a single stylist object
  define_singleton_method(:find) do |options|
    target_id   = options.fetch(:id, nil)
    target_name = options.fetch(:name, nil)

    stylists = []

    # Not expecting user to search by id and name
    if target_id
      returned_stylist = DB.exec("SELECT * FROM stylists WHERE id=#{target_id};").first
      id         = returned_stylist.fetch("id").to_i
      first_name = returned_stylist.fetch("first_name")
      last_name  = returned_stylist.fetch("last_name")
      stylists << Stylist.new(id: id, first_name: first_name, last_name: last_name)
    end

    if target_name
      stylists = []
      returned_stylists = DB.exec("SELECT * FROM stylists WHERE first_name LIKE '%#{target_name}%';")
      returned_stylists.each do |stylist|
        id         = returned_stylist.fetch("id").to_i
        first_name = returned_stylist.fetch("first_name")
        last_name  = returned_stylist.fetch("last_name")
        stylists << Stylist.new(id: id, first_name: first_name, last_name: last_name)
      end
    end

    stylists

  end

  # Returns an array of stylist objects
  define_singleton_method(:all) do
    stylists = []
    returned_stylists = DB.exec("SELECT * FROM stylists")
    returned_stylists.each do |stylist|
      id         = stylist.fetch("id").to_i
      first_name = stylist.fetch("first_name")
      last_name  = stylist.fetch("last_name")
      stylists << Stylist.new(id: id, first_name: first_name, last_name: last_name)
    end
    stylists
  end

  define_singleton_method(:clear) do
    DB.exec("DELETE FROM stylists")
  end
end
