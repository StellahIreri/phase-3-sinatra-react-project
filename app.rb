require 'sinatra'
require 'sinatra/activerecord'
require 'json'

# Database configuration
set :database, 'sqlite3:event_app_db.sqlite3' # Adjust the database name as needed

# Model for the "Event" entity
class Event < ActiveRecord::Base
end

# Create an event
post '/events' do
    request_body = JSON.parse(request.body.read)
    event = Event.create(request_body)
    event.to_json
  end
  
  # Get all events
  get '/events' do
    events = Event.all
    events.to_json
  end
  
  # Get a specific event by id
  get '/events/:id' do
    event = Event.find(params[:id])
    event.to_json
  end
  
  # Update an event
  put '/events/:id' do
    event = Event.find(params[:id])
    request_body = JSON.parse(request.body.read)
    event.update(request_body)
    event.to_json
  end
  
  # Delete an event
  delete '/events/:id' do
    event = Event.find(params[:id])
    event.destroy
    { message: 'Event deleted successfully' }.to_json
  end
