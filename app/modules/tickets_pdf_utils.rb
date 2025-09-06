module TicketsPdfUtils

    def generate_tickets_pdf (event,tickets, root_url)
        pdf = TicketsPdf.new(tickets, event, root_url)
        f = Tempfile.new("tests_pdf")
        pdf.render_file f
        f.flush
        File.read(f)
    end

    def tickets_pdf_name(event, person)
        return "YourTickets - #{event.title}.pdf"
    end
end
