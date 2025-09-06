class TicketsController < ApplicationController
  include QrUtils
  include TicketsPdfUtils

  before_action :set_ticket, only: %i[ email show edit update destroy flag_attended]
  load_and_authorize_resource :except => [:show, :flag_attended, :email]
  before_action :authenticate_user!, except: [:show, :flag_attended, :email] 
  # GET /tickets or /tickets.json
  def index
    @tickets = Ticket.all
  end

  # GET /tickets/1 or /tickets/1.json
  def show
    @qrcode = get_qr_code(abs_url(root_url, ticket_path(@ticket)))
    respond_to do |format|
      format.html
      format.pdf do
        #pdf = TestReportPdf.new(@test)
        @event = @ticket.event
        @tickets = [@ticket]
        pdf_file_name= "#{@ticket.ticket_no}.pdf"

        pdf = generate_tickets_pdf(@event, @tickets, root_url)
        send_data pdf, filename: pdf_file_name.gsub('-','_') , type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def flag_attended
    if @ticket.attendable?  
      @ticket.attended_at = DateTime.now
      if @ticket.save
        redirect_to request.referrer, notice: "Ticket marked attended." 
      else
        redirect_to request.referrer, flash:  {error: "Unable to update ticket" } 
      end
    end

  end

  
  # GET /tickets/new
  def new
    @ticket = Ticket.new
    @agents = Person.all
    @people = Person.all
  end

  # GET /tickets/1/edit
  def edit
    @agents = Person.all
    @people = Person.all
  end

  # POST /tickets/1/email
  def email
    if (@ticket.person)
      TicketMailer.send_tickets_of_person(@ticket.person, @ticket.event, [@ticket]).deliver_now
      redirect_to request.referrer, notice: "Ticket Emailed to #{@ticket.person&.email}"
    else
      redirect_to request.referrer, flash: {error: "Ticket has not been sold yet." }
    end
  end

  # POST /tickets or /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to ticket_url(@ticket), notice: "Ticket was successfully created." }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1 or /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to ticket_url(@ticket), notice: "Ticket was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1 or /tickets/1.json
  def destroy
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to tickets_url, notice: "Ticket was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:event_id, :seq, :type, :state, :price, :agent_id, :person_id, :table_id, :notes, :attended_at)
    end
  
end
