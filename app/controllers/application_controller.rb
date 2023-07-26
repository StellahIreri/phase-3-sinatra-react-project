class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

    # Get all events
    get '/events' do
      events = Event.all
      events.to_json
    end
  # Define the route for creating events
post '/events' do
  # Parse the JSON data sent in the request body
  request_data = JSON.parse(request.body.read)

  # Assuming you have an Event model with the events table in the database
  event = Event.create(
    title: request_data['title'],
    description: request_data['description'],
    start_time: request_data['start_time'],
    end_time: request_data['end_time'],
    location: request_data['location'],
    organizer: request_data['organizer']
  )
  
  content_type 'application/json'
  event.to_json
  if event.save
    status 201 # Created
    { message: 'Event created successfully', event: event }.to_json
  else
    status 422 # Unprocessable Entity
    { message: 'Event creation failed', errors: event.errors.full_messages }.to_json
  end
end
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



