class TicketSelection 
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    attr_accessor :ticket, :selected, :ticket_id
    @ticket
    @selected

    def initialize(ticket, selected)
        @ticket = ticket
        @selected=selected
    end
    
    def ticket_id
        @ticket.id
    end

    def persisted?
        false
    end
end