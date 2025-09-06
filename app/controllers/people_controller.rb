class PeopleController < ApplicationController
  include TicketsPdfUtils

  before_action :set_person, only: %i[agent_profile email show edit update destroy ]
  before_action :authenticate_user!, except: [:show, :email]
  # GET /people or /people.json
  def index
    @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        #pdf = TestReportPdf.new(@test)
        @event = Event.find(params[:event_id])
        @tickets = @person.tickets.where(event: @event).order(:ticket_type)
        pdf_file_name= tickets_pdf_name(@event, @person)

        pdf = generate_tickets_pdf(@event, @tickets, root_url)
        send_data pdf, filename: pdf_file_name.gsub('-','_') , type: 'application/pdf', disposition: 'inline'
      end
    end

  end

  # GET /people/new
  def new
    @person = Person.new
  end

  def email
    @event = Event.find(params[:event_id])
    @tickets = @person.tickets.where(event: @event).order(:ticket_type)

    TicketMailer.send_tickets_of_person(@person, @event, @tickets).deliver_now
    redirect_to request.referrer, notice: "'#{@event.title}' tickets emailed to `#{@person.email}` "
  end
  # GET /people/1/edit
  def edit
  end

  def agent_profile
    @event = Event.find(params['event_id'])
    @tickets = @event.tickets.where(agent: [@person] ) # ,nil
  end
  
  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:name, :email, :phone, :user_id)
    end
end
