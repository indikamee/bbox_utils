class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy bulk_edit bulk_update show_tickets bulk_email]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
    @agents = Person.with_any_role ({name: :agent, resource: @event})
    @tickets = @event.tickets
  end


  def show_tickets
    @tickets = @event.tickets

    @table_id = params[:table_id]
    @tickets = @tickets.where(table_id: @table_id )  
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @agents = Person.with_any_role ({name: :agent, resource: @event})
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /events/1/bulk_edit
  def bulk_edit
    @tickets = Ticket.where(event: @event).accessible_by(current_ability, :update)
    if params.has_key?(:agent_id)
      @tickets = @tickets.where(agent_id: [params[:agent_id], nil])  
    end
    @agents = Person.with_any_role ({name: :agent, resource: @event})
    @people = Person.all
    @bulk_ticket_details = BulkTicketDetails.new 
    @ticket_selection = []
    @tickets.each do |t|
       @ticket_selection.push (TicketSelection.new(t, false))
    end   
  end

  def bulk_email
    @agent = Person.find(params[:agent_id])
    @tickets = Ticket.where(event: @event, agent: @agent, state: [:paid, :sold])
    person_ids = @tickets.pluck(:person_id).uniq

    person_ids.each do |person_id|
      @person = Person.find(person_id)
      tickets = @tickets.where(person_id: person_id)
      TicketMailer.send_tickets_of_person(@person, @event, tickets.to_a).deliver_later
    end
    redirect_to request.referrer, notice: "#{@tickets.count} tickets successfully emailed to #{person_ids.count} emails." 
  end
  # POST /events/1/bulk_update
  def bulk_update
    @bulk_properties = params['bulk_ticket_details']
    cnt = 0
    params['ticket_selection'].each do |ticket_sel|
      puts ticket_sel
      if (ticket_sel["selected"] == "1")
        ticket=Ticket.find(ticket_sel["ticket_id"])
        (ticket.agent_id = @bulk_properties["agent_id"]) if @bulk_properties["agent_id"].present? 
        (ticket.person_id = @bulk_properties["person_id"]) if @bulk_properties["person_id"].present?
        (ticket.table_id = @bulk_properties["table_id"]) if @bulk_properties["table_id"].present?
        (ticket.state = @bulk_properties["state"]) if @bulk_properties["state"].present?
        (ticket.notes = @bulk_properties["notes"]) if @bulk_properties["notes"].present?
        (ticket.price = @bulk_properties["price"]) if @bulk_properties["price"].present?
        ticket.save!
        cnt = cnt +1
      end
    end
    
    if request.referrer.present?
      redirect_to request.referrer, notice: "#{cnt} tickets updated successfully."
    else
      redirect_to root_path, notice: "#{cnt} tickets updated successfully."
    end
    #render plain: params.inspect

  end


  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :state)
    end
end
