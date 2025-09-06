class TicketMailer < ApplicationMailer
  include TicketsPdfUtils

  def send_ticket(ticket)
    @ticket = ticket
    #attachments['filename.html'] = File.read('/media/indika/DATA/SHARE/Documents/Programming/workspace/ScholDb/out/1_UMAAV.html')
    #attachments[@sponsor.full_name+'_Summary.pdf'] = {mime_type: 'application/pdf', content: generate_sponsor_pdf_content(sponsor)}
    #attachments['UMAAV Scholarship Program.pdf'] = File.read('app/assets/images/ScholarshipPrgram_Feedback.pdf')
    #@sponsor.scholarships.sort_by{|x| x.start_date}.reverse.each do |schol|
    #  attachments['Scholarhsip_'+schol.student.external_name+'.pdf'] = {mime_type: 'application/pdf', content: generate_student_pdf_content(schol.student)}
    #end
    mail(
         to: 'events@umaav.org.au',
         #to: 'secretary@umaav.org.au', 
         #cc: 'scholarships@umaav.org.au,president@umaav.org.au,secretary@umaav.org.au',
         #Bcc: 'nishantha.rajapakshe@gmail.com,randykaru@gmail.com,marasinghe@gmail.com,dassa.dml@gmail.com,kaushalye@gmail.com',
         subject: "Your ticket: #{@ticket.event.title} - #{@ticket.ticket_no} ( #{@ticket.ticket_type} $ #{@ticket.price} )")
      #mail(to: @sponsor.full_name+'.eml', subject: 'Your UMAAV Scholarship Summary - ' +  @sponsor.title  + ' ' + @sponsor.full_name)
  end

  def send_tickets_of_person(person, event, tickets)
    @person = person
    @event = event
    @tickets = tickets
    attachments[tickets_pdf_name(@event,@person)] = {mime_type: 'application/pdf', content: generate_tickets_pdf(event,tickets, root_url)}
    mail(
      to: "#{@person.email}", 
      cc: "events@umaav.org.au,#{@tickets[0].agent&.email}",
      #Bcc: 'nishantha.rajapakshe@gmail.com,randykaru@gmail.com,marasinghe@gmail.com,dassa.dml@gmail.com,kaushalye@gmail.com',
      subject: "Your tickets - #{@event.title}")
  end
  

  
  
end
