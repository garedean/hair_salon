##Hair Salon

Author: Garrett Olson

Description: the Hair Salon app is a Sinatra application that allows a salon to track clients, stylists, and assign clients to stylists. Each client pledges allegiance to one stylist creating a one (stylist) to many (clients) relationship.

#Setup

Boot up a local Sinatra server (localhost:4567) and navigate to the root directory ('/'). Let the intuitive UI guide you.

#Database Setup, PSQL

username=# CREATE DATABASE hair_salon;
username=# \c hair_salon;
hair_salon=# CREATE TABLE stylists (id serial PRIMARY KEY, first_name varchar, last_name varchar);
hair_salon=# CREATE TABLE clients (id serial PRIMARY KEY, first_name varchar, last_name varchar, stylist_id int);

After setting up the hair_salon database, use the following to create a 'test' database using it as a template:

CREATE DATABASE hair_salon_test WITH TEMPLATE hair_salon;

#Copyright and license

Code and documentation copyright 2015 Garrett Olson. The Online Dictionary is released under the [MIT license](http://opensource.org/licenses/MIT)
