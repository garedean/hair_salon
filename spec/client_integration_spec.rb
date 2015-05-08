require('capybara/rspec')
require('./app')
require('spec_helper')
set(:show_exceptions, false)

Capybara.app = Sinatra::Application

describe("the hair salon app", :type => :feature) do

  describe("add a client page") do
    it('allows a user to add a client starting with no clients') do
      visit('/')
      click_link('No clients exist, click to add')
      fill_in('first_name', with: "Lindsay")
      fill_in('last_name', with: "Culver")
      click_button('Add Client')
      expect(page).to(have_content("Lindsay Culver Client at Lluminaire Salon"))
    end

    it('allows a user to add a client when clients exist') do
      add_client("Lindsay", "Culver")
      visit('/')
      click_link('Clients')
      click_link('add one')
      fill_in('first_name', with: "Lindsay")
      fill_in('last_name', with: "Culver")
      click_button('Add Client')
      expect(page).to(have_content("Lindsay Culver Client at Lluminaire Salon"))
    end
  end

  describe("client page for a single client") do
    it('allows a user to update the client first and last name') do
      client = add_client("Lindsay", "Culver")
      visit("/clients/#{client.id}")
      fill_in('first_name', with: "Bill")
      fill_in('last_name', with: "Brasky")
      click_button('Update')
      expect(page).to(have_content("Bill Brasky"))
    end

    it('allows a user to delete a client') do
      client = add_client("Lindsay", "Culver")
      visit("/clients/#{client.id}")
      click_button('Delete')
      expect(page).not_to(have_content("Lindsay Culver"))
    end
  end

  describe("clients page listing all clients") do
    it('lists clients') do
      client = add_client("Lindsay", "Culver")
      client = add_client("Bill", "Brasky")
      visit("/clients")
      expect(page).to(have_content("Lindsay Culver"))
      expect(page).to(have_content("Bill Brasky"))
    end

    it('allows a user to delete a client') do
      client = add_client("Lindsay", "Culver")
      visit("/clients/#{client.id}")
      click_button('Delete')
      expect(page).not_to(have_content("Lindsay Culver"))
      expect(page).to(have_content("Looks like you're all out of clients."))
    end
  end
end
