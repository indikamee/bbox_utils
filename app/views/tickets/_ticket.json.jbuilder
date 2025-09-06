json.extract! ticket, :id, :event_id, :code, :ticket_type, :state, :price, :agent, :person_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
