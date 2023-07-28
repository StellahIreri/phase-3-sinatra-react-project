class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

    # Get all events
    get '/events' do
      events = Event.all.map do |event|
        {
          id: event.id,
          title: event.title,
          description: event.description,
          start_time: event.start_time,
          end_time: event.end_time,
          location: event.location,
          organizer: event.organizer,
          imageUrl: event.image_url,
        }
      end
      content_type 'application/json'
      events.to_json
    end

    # Get a specific event by id
  get '/events/:id' do
    event_id = params[:id].to_i
    event = Event.find { |event| event[:id] == event_id }
    if event
      content_type :json
      event.to_json
    else
      status 404
      'Event not found'
    end
  end
  
  # Define the route for creating events
  post '/events' do
    # Parse the JSON data sent in the request body
    request_data = JSON.parse(request.body.read)
  
    # Assuming you have an Event model with the events table in the database
    event = Event.new(
      title: request_data['title'],
      description: request_data['description'],
      start_time: request_data['start_time'],
      end_time: request_data['end_time'],
      location: request_data['location'],
      organizer: request_data['organizer'],
      image_url: request_data['imageUrl']
    )
  
    content_type 'application/json'
    
    if event.save
      status 201 # Created
      { message: 'Event created successfully', event: event }.to_json
    else
      status 422 # Unprocessable Entity
      { message: 'Event creation failed', errors: event.errors.full_messages }.to_json
    end
  end
  
  
  
  # Update an event
  put '/events/:id' do
    event = Event.find(params[:id])
    request_data = JSON.parse(request.body.read)

    # Update event attributes, including the image_url
    event.update(
      title: request_data['title'],
      description: request_data['description'],
      start_time: request_data['start_time'],
      end_time: request_data['end_time'],
      location: request_data['location'],
      organizer: request_data['organizer'],
      image_url: request_data['imageUrl'] # Add image_url attribute
    )

  
    content_type 'application/json'
    if event.save
      { message: 'Event updated successfully', event: event }.to_json
    else
      status 422 # Unprocessable Entity
      { message: 'Event update failed', errors: event.errors.full_messages }.to_json
    end
  end
  

  # Delete an event#
  delete '/events/:id' do
    event = Event.find(params[:id])
    event.destroy
    { message: 'Event has been deleted successfully' }.to_json
  end



end
