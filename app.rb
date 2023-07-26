require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require_relative 'app/models/event'
require 'rack/cors'

# Database configuration
set :database, 'sqlite3:event_app_db.sqlite3' # Adjust the database name as needed

use Rack::Cors do
  allow do
    origins '*' # You can replace '*' with the URL of your React app if needed
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end

# Create an event
post '/events' do
  # Extract the event data from the request JSON body
  request_body = JSON.parse(request.body.read)

  # Create a new event object using the data from the request body
  event = Event.new(
    title: request_body['title'],
    description: request_body['description'],
    start_time: request_body['start_time'],
    end_time: request_body['end_time'],
    location: request_body['location'],
    organizer: request_body['organizer']
  )
# Save the event to the database
if event.save
  status 201 # HTTP status code for 'Created'
  json event # Return the newly created event as JSON response
else
  status 422 # HTTP status code for 'Unprocessable Entity' (Validation failed)
  json error: "Unable to create the event."
end
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

