require('capybara/rspec')
require('./app')
require('spec_helper')
set(:show_exceptions, false)

Capybara.app = Sinatra::Application

describe("the hair salon app", :type => :feature) do

  describe("add a stylist page") do
    it('allows a user to add a stylist starting with no stylists') do
      visit('/')
      click_link('No stylists exist, click to add')
      fill_in('first_name', with: "Lindsay")
      fill_in('last_name', with: "Culver")
      click_button('Add Stylist')
      expect(page).to(have_content("Lindsay Culver Stylist at Lluminaire Salon"))
    end

    it('allows a user to add a stylist when stylists exist') do
      add_stylist("Lindsay", "Culver")
      visit('/')
      click_link('Stylists')
      click_link('add one')
      fill_in('first_name', with: "Lindsay")
      fill_in('last_name', with: "Culver")
      click_button('Add Stylist')
      expect(page).to(have_content("Lindsay Culver Stylist at Lluminaire Salon"))
    end
  end

  describe("stylist page for a single stylist") do
    it('allows a user to update the stylist first and last name') do
      stylist = add_stylist("Lindsay", "Culver")
      visit("/stylists/#{stylist.id}")
      fill_in('first_name', with: "Bill")
      fill_in('last_name', with: "Brasky")
      click_button('Update')
      expect(page).to(have_content("Bill Brasky"))
    end

    it('allows a user to delete a stylist') do
      stylist = add_stylist("Lindsay", "Culver")
      visit("/stylists/#{stylist.id}")
      click_button('Delete')
      expect(page).not_to(have_content("Lindsay Culver"))
    end
  end

  describe("stylists page listing all stylists") do
    it('lists all stylists') do
      stylist = add_stylist("Lindsay", "Culver")
      stylist = add_stylist("Bill", "Brasky")
      visit("/stylists")
      expect(page).to(have_content("Lindsay Culver"))
      expect(page).to(have_content("Bill Brasky"))
    end

    it('allows a user to delete a stylist') do
      stylist = add_stylist("Lindsay", "Culver")
      visit("/stylists/#{stylist.id}")
      click_button('Delete')
      expect(page).not_to(have_content("Lindsay Culver"))
    end
  end
end
