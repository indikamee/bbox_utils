require 'stringio'
require 'open-uri'

class TicketsPdf < Prawn::Document
    include QrUtils

    def initialize(tickets, event, root_url)
        super(page_size: 'A4', page_layout: :portrait)
        @tickets = tickets
        @event = event
        @root_url = root_url
        print_tickets
    end

    def print_tickets
        text "Your Tickets for the #{@event.title}", size: 16, style: :bold
        @tickets.each do |ticket|
            add_a4_ticket(ticket)
        end
    end

    def add_a4_ticket(ticket)

        qrcode = get_qr_code(abs_url(@root_url, Rails.application.routes.url_helpers.ticket_path(ticket)))
            qrpng = get_qr_png(qrcode,120)
            if cursor < 250 
                start_new_page
            else
                move_down 20
            end
            text "#{ticket.ticket_no} ( #{ticket.ticket_type} $ #{ticket.price} )", size: 10, color: '000000'
            text "Sold by: #{ticket.agent&.name}", size: 10, color: '000000'
            text "Allocated to: #{ticket.person&.name}", size: 10, color: '000000'
            move_down 5
            text "This is an e-Ticket. Please present this QR code at the entrance", size: 12, style: :bold
            span( bounds.width, position: :center) do
                bounding_box([0,cursor], width: bounds.width) do
                    #img_url = ticket.ticket_type.eql?('Kids') ? 'https://drive.google.com/uc?id=1bc3OY15EUmdKpl2WvUqi9Syb2ncmlTMH': 'https://drive.google.com/uc?id=1EnPYHJa5EB16KNDQfY3h3siZsfb_G9DN'
                    img_url = Rails.root.join('app', 'assets', 'images', 'Pedura2025.jpg')
                    # Center the image
                    image_width = 440
                    image_position = (bounds.width - image_width) / 2.0
                    image( URI.open(img_url), width: image_width, position: image_position)
                    case ticket.ticket_type
                    when 'Kids'
                        fill_color 'FFD700'
                    when 'Student'
                        fill_color '8B0000'
                    else
                        fill_color 'ffffff'
                    end
                    #text_box "#{ticket.ticket_no}", at: [70,25], width: 250, size: 14, style: :bold
                    text_box "#{ticket.ticket_type} #{ticket.ticket_no}", at: [350,160], width: 250, size: 16, style: :bold
                    fill_color '000000'
                    #text_box "#{ticket.ticket_type} $#{'%.0f' % ticket.price}", at: [170,170], width: 250, size: 28
                    image StringIO.new(qrpng.to_s), at: [350,140]
                end
            end
    end

    def add_b5_ticket(ticket)
        #start_new_page if !first_page
        qrcode = get_qr_code(abs_url(@root_url, Rails.application.routes.url_helpers.ticket_path(ticket)))
        qrpng = get_qr_png(qrcode,120)
        if cursor < 250 
            start_new_page
        else
            move_down 20
        end
        text "#{ticket.ticket_no} ( #{ticket.ticket_type} $ #{ticket.price} )", size: 10, color: '000000'
        text "Sold by: #{ticket.agent&.name}", size: 10, color: '000000'
        text "Allocated to: #{ticket.person&.name}", size: 10, color: '000000'
        move_down 5
        text "This is an e-Ticket. Please present this QR code at the entrance", size: 12, style: :bold
        span( bounds.width, position: :center) do
            bounding_box([0,cursor], width: bounds.width) do
                #img_url = ticket.ticket_type.eql?('Kids') ? 'https://drive.google.com/uc?id=1bc3OY15EUmdKpl2WvUqi9Syb2ncmlTMH': 'https://drive.google.com/uc?id=1EnPYHJa5EB16KNDQfY3h3siZsfb_G9DN'
                img_url = Rails.root.join('app', 'assets', 'images', "SE24_#{ticket.ticket_type}.jpg")
                # Center the image
                image_width = 550
                image_position = (bounds.width - image_width) / 2.0
                image(open(img_url), width: image_width, position: image_position)
                case ticket.ticket_type
                when 'Kids'
                    fill_color 'FFD700'
                when 'Student'
                    fill_color '8B0000'
                else
                    fill_color 'ffffff'
                end
                #text_box "#{ticket.ticket_no}", at: [70,25], width: 250, size: 14, style: :bold
                text_box "#{ticket.ticket_type} #{ticket.ticket_no}", at: [20,160], width: 250, size: 16, style: :bold
                fill_color '000000'
                #text_box "#{ticket.ticket_type} $#{'%.0f' % ticket.price}", at: [170,170], width: 250, size: 28
                image StringIO.new(qrpng.to_s), at: [20,140]
            end
        end
    end
        

end