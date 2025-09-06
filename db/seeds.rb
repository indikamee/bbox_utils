# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

event=Event.create!({title: 'Melmora Dinner Dance 2023', state: 'open'})

10.times do |index|
  Ticket.create!({event_id: event.id, seq: index, state: :new, price: 100, ticket_type: 'Adult'})
end

10.times do |index|
  Ticket.create!({event_id: event.id, seq: index, state: :new, price: 45, ticket_type: 'Kids'})
end

10.times do |index|
  Ticket.create!({event_id: event.id, seq: index, state: :new, price: 70, ticket_type: 'Students'})
end

10.times do |index|
  Agent.create!({name: "Agent #{index}",
                email: "agent_#{index}@foo.com",
                phone: '12345678'
                })
end

10.times do |index|
  Person.create!({name: "Person #{index}",
                email: "person_#{index}@foo.com",
                phone: '12345678'
                })
end

Role.create(name: :admin)
Role.create(name: :agent)
user1 = User.create(username: 'Indika',
  email: 'admin@gmail.com',
  password: 'password1234',
  password_confirmation: 'password1234')
user1.add_role(:admin)