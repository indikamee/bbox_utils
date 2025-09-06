class BulkTicketDetails 
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :person_id, :agent_id, :state, :table_id, :notes, :price

    @person_id
    @state
    @agent_id
    @table_id
    @notes
    @price


end