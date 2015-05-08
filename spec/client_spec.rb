require('spec_helper')

# Note: I created a 'global' helper method called 'add_client' that makes
# instantiating and saving clients faster. Check out 'spec_helper' for details

describe('client') do
  describe('#id') do
    it('returns the client id') do
      client = add_client('Lindsay', 'Culver')
      expect(client.id).to(be_an_instance_of(Fixnum))
    end
  end

  describe('#first_name') do
    it('returns the first name of a client') do
      client = add_client('Lindsay', 'Culver')
      expect(client.first_name).to(eq('Lindsay'))
    end
  end

  describe('#last_name') do
    it('returns the first name of a client') do
      client = add_client('Lindsay', 'Culver')
      expect(client.last_name).to(eq('Culver'))
    end
  end

  describe('#full_name') do
    it('returns the full name of a client') do
      client = add_client('Lindsay', 'Culver')
      expect(client.full_name).to(eq('Lindsay Culver'))
    end
  end

  describe('#save') do
    it('will save a client to the database') do
      client1 = client.new(id: nil, first_name: 'Lindsay', last_name: 'Culver').save()
      expect(client.all()).to(eq([client1]))
    end
  end

  describe('#update') do
    it('will update a client first name') do
      client = add_client('Lindsay', 'Culver')
      client.update(first_name: 'Lindz')
      expect(client.find(id: client.id).first.first_name).to(eq("Lindz"))
    end

    it('will update a client last name') do
      client = add_client('Lindsay', 'Culver')
      client.update(last_name: 'Culvz')
      expect(client.find(id: client.id).first.last_name).to(eq("Culvz"))
    end

    it('will update a client first and last name at the same time') do
      client = add_client('Lindsay', 'Culver')
      client.update(first_name: "Lindz", last_name: 'Culvz')
      expect(client.find(id: client.id).first.full_name).to(eq("Lindz Culvz"))
    end
  end

  describe('#delete') do
    it('will delete a specific client in the database') do
      client1 = add_client('Lindsay', 'Culver')
      client2 = add_client('Garrett', 'Olson')
      expect(client.all).to(eq([client1, client2]))
      client2.delete()
      expect(client.all).to(eq([client1]))
    end
  end

  describe('#find') do
    it('returns an array containing one client object when searching by id') do
      client1 = add_client('Lindsay', 'Culver')
      client2 = add_client('Garrett', 'Olson')
      expect(client.find(id: client1.id)).to(eq([client1]))
    end

    it('returns an array containing one client object when searching by part of a name (e.g. first name)') do
      client1 = add_client('Lindsay', 'Culver')
      client2 = add_client('Garrett', 'Olson')
      expect(client.find(name: client1.first_name)).to(eq([client1]))
    end

    it('returns an array containing one client object when searching by full name') do
      client1 = add_client('Lindsay', 'Culver')
      client2 = add_client('Garrett', 'Olson')
      expect(client.find(name: client1.full_name)).to(eq([client1]))
    end
  end

  describe('.all') do
    it('will return an empty array when no clients') do
      expect(client.all()).to(eq([]))
    end

    it('will return an array with a single client when one exists') do
      client = add_client('Lindsay', 'Culver')
      expect(client.all()).to(eq([client]))
    end

    it('will return an array of multiple clients when multiple exist') do
      client1 = add_client('Lindsay', 'Culver')
      client2 = add_client('Bill', 'Brasky')
      expect(client.all()).to(eq([client1, client2]))
    end
  end

  describe('.clear') do
    it('will clear all clients from the database') do
      client = add_client('Lindsay', 'Culver')
      expect(client.all()).to(eq([client]))
      client.clear()
      expect(client.all()).to(eq([]))
    end
  end
end
