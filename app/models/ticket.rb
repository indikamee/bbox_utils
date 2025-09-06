class Ticket < ApplicationRecord
  belongs_to :event
  belongs_to :person, class_name: 'Person', foreign_key: :person_id, optional: true
  belongs_to :agent, class_name: 'Person', foreign_key: :agent_id, optional: true

  STATES = [:new, :allocated, :sold, :paid, :cancelled]

  after_validation :update_state

  def ticket_no
    return ticket_type[0] + format("%04d",seq)
  end

  def attendable?
    return ([:sold, :paid].include? self.state.to_sym) && 
    (self.event.state == "in_progress") && 
    (self.attended_at.nil?)
  end

private
  
def update_state
    case self.state 
    when "new", "allocated"
      self.state = :allocated.to_s if self.agent.present?
      self.state = :sold.to_s if self.person.present?
    end
  end
end
