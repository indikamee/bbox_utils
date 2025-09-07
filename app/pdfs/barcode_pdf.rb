require "barby"
require "barby/barcode/code_25_interleaved"
require "barby/outputter/prawn_outputter"

class BarcodePdf < Prawn::Document
  def initialize(barcode_no, name, description)
    super(page_size: [to_pts(150), to_pts(100)], margin: 0) # disable default margin
    @barcode_no   = barcode_no.to_s.rjust(14, "0") # ensure 14 digits
    @name         = name
    @description  = description
    print_barcode
  end

  def to_pts(mm)
    (mm * 2.83465).round(2)
  end

  def print_barcode
    barcode_width  = to_pts(120)
    barcode_height = to_pts(32)
    barcode = Barby::Code25Interleaved.new(@barcode_no)
    
    # Absolute text (no span/bounding_box needed)
    draw_text "Cat No. #{@name}", at: [to_pts(15), to_pts(75)], size: 12, style: :bold
    desc_text = @description.to_s
    text_width = width_of(desc_text, size: 12, style: :bold)
    x_right = to_pts(135) - text_width
    draw_text desc_text, at: [x_right, to_pts(75)], size: 12, style: :bold

    # Draw rectangle for barcode
    x0 = to_pts(15)
    y0 = to_pts(70)
    line_width(2)
    stroke_rectangle [x0, y0], barcode_width, barcode_height

    # Draw barcode inside rectangle
    op=Barby::PrawnOutputter.new(barcode)
    op.xdim = to_pts(100) / op.full_width  # scale each module
    op.annotate_pdf(
      self,
      x: to_pts(25),
      y: y0 - to_pts(32),
      width: to_pts(100),
      height: to_pts(32)
    )

    # Barcode number under barcode
    text_width = width_of(@barcode_no, size: 12, style: :bold)
    x_center = (bounds.width - text_width) / 2
    draw_text @barcode_no, at: [x_center, to_pts(30)], size: 12, style: :bold
  end
end
