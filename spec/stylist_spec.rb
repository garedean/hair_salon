require('spec_helper')

# Note: I created a 'global' helper method called 'add_stylist' that makes
# instantiating and saving stylists faster. Check out 'spec_helper' for details

describe('Stylist') do

  describe('#==') do
    it('returns true when two objects are functionally the same') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(Stylist.all).to(eq([stylist]))
    end
  end

  describe('#id') do
    it('returns the stylist id') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(stylist.id).to(be_an_instance_of(Fixnum))
    end
  end

  describe('#first_name') do
    it('returns the first name of a stylist') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(stylist.first_name).to(eq('Lindsay'))
    end
  end

  describe('#last_name') do
    it('returns the first name of a stylist') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(stylist.last_name).to(eq('Culver'))
    end
  end

  describe('#full_name') do
    it('returns the full name of a stylist') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(stylist.full_name).to(eq('Lindsay Culver'))
    end
  end

  describe('#save') do
    it('will save a stylist to the database') do
      stylist1 = Stylist.new(id: nil, first_name: 'Lindsay', last_name: 'Culver').save()
      expect(Stylist.all()).to(eq([stylist1]))
    end
  end

  describe('#update') do
    it('will update a stylist first name') do
      stylist = add_stylist('Lindsay', 'Culver')
      stylist.update(first_name: 'Lindz')
      expect(Stylist.find(id: stylist.id).first.first_name).to(eq("Lindz"))
    end

    it('will update a stylist last name') do
      stylist = add_stylist('Lindsay', 'Culver')
      stylist.update(last_name: 'Culvz')
      expect(Stylist.find(id: stylist.id).first.last_name).to(eq("Culvz"))
    end

    it('will update a stylist first and last name at the same time') do
      stylist = add_stylist('Lindsay', 'Culver')
      stylist.update(first_name: "Lindz", last_name: 'Culvz')
      expect(Stylist.find(id: stylist.id).first.full_name).to(eq("Lindz Culvz"))
    end
  end

  describe('#delete') do
    it('will delete a specific stylist in the database') do
      stylist1 = add_stylist('Lindsay', 'Culver')
      stylist2 = add_stylist('Garrett', 'Olson')
      expect(Stylist.all).to(eq([stylist1, stylist2]))
      stylist2.delete()
      expect(Stylist.all).to(eq([stylist1]))
    end
  end

  describe('#clients') do
    it('returns empty array when no clients are assigned to a stylist') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(stylist.clients).to(eq([]))
    end
    it('returns array of clients that are assigned to stylist') do
      stylist = add_stylist('Lindsay', 'Culver')
      client1  = add_client('Garrett', 'Olson')
      client2  = add_client('Brandon', 'LaRose')
      client1.assign_stylist(stylist.id)
      client2.assign_stylist(stylist.id)
      expect(stylist.clients).to(eq([client1, client2]))
    end
  end

  describe('#find') do
    it('returns an array containing one stylist object when searching by id') do
      stylist1 = add_stylist('Lindsay', 'Culver')
      stylist2 = add_stylist('Garrett', 'Olson')
      expect(Stylist.find(id: stylist1.id)).to(eq([stylist1]))
    end

    # it('returns an array containing one stylist object when searching by part of a name (e.g. first name)') do
    #   stylist1 = add_stylist('Lindsay', 'Culver')
    #   stylist2 = add_stylist('Garrett', 'Olson')
    #   expect(Stylist.find(name: stylist1.first_name)).to(eq([stylist1]))
    # end

    # it('returns an array containing one stylist object when searching by full name') do
    #   stylist1 = add_stylist('Lindsay', 'Culver')
    #   stylist2 = add_stylist('Garrett', 'Olson')
    #   expect(Stylist.find(name: stylist1.full_name)).to(eq([stylist1]))
    # end
  end

  describe('.all') do
    it('will return an empty array when no stylists') do
      expect(Stylist.all()).to(eq([]))
    end

    it('will return an array with a single stylist when one exists') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(Stylist.all()).to(eq([stylist]))
    end

    it('will return an array of multiple stylists when multiple exist') do
      stylist1 = add_stylist('Lindsay', 'Culver')
      stylist2 = add_stylist('Bill', 'Brasky')
      expect(Stylist.all()).to(eq([stylist1, stylist2]))
    end
  end

  describe('.clear') do
    it('will clear all stylists from the database') do
      stylist = add_stylist('Lindsay', 'Culver')
      expect(Stylist.all()).to(eq([stylist]))
      Stylist.clear()
      expect(Stylist.all()).to(eq([]))
    end
  end
end
