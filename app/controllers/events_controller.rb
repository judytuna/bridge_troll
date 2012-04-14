class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @volunteers = VolunteerRsvpRole.where(:event_id => params[:id], :attending => true)
    @teachers = []
    @tas = []
    
    @volunteers.each do |v|
      user = User.find(v.user_id)
      if (user.teaching)
        @teachers << user
      end
    end
    
    @volunteers.each do |v|
      user = User.find(v.user_id)
      if (user.taing)
        @tas << user
      end
    end
  
    respond_to do |format|
      
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def volunteer
     redirect_to "/events" and return if !user_signed_in?
     
     @event = Event.find(params[:id])
     @rsvp = @event.volunteer(current_user)
      
     if @rsvp.persisted?
       redirect_to events_path, notice: 'Thanks for volunteering!'
     else
       redirect_to events_path, notice: 'You are already registered to volunteer for the event!'
     end
  end
  
  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
end
