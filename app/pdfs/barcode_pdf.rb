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
    barcode_height = to_pts(33)

    # --- barcode object --- #
    barcode = Barby::Code25Interleaved.new(@barcode_no)

    # Set wide:narrow ratio (wide_width is in "xdim" units on the barcode object)
    # default wide is typically 3.0; we want 3.33
    barcode.wide_width = 3.33

    # --- header text --- #
    draw_text "Cat No. #{@name}", at: [to_pts(15), to_pts(75)], size: 12, style: :bold
    desc_text = @description.to_s
    desc_width = width_of(desc_text, size: 12, style: :bold)
    x_right = to_pts(135) - desc_width
    draw_text desc_text, at: [x_right, to_pts(75)], size: 12, style: :bold

    # --- barcode rectangle --- #
    x0 = to_pts(15)
    y0 = to_pts(70)
    line_width(2)
    stroke_rectangle [x0, y0], barcode_width, barcode_height

    # --- outputter & scale to fit inside rectangle --- #
    outputter = Barby::PrawnOutputter.new(barcode)

    # Choose how much horizontal space inside the rectangle you want the barcode to occupy.
    # (I keep 10mm left/right inner margin like your previous values: 120 total -> 100 used)
    inner_margin_left_mm = 10
    inner_margin_right_mm = 10
    inner_width = barcode_width - to_pts(inner_margin_left_mm) - to_pts(inner_margin_right_mm)

    # op.full_width is the number of "xdim" units wide the barcode will be when xdim == 1.
    # So set xdim so full_width * xdim == inner_width.
    outputter.xdim = inner_width.to_f / outputter.full_width

    # Annotate the PDF (place the barcode inside the rectangle)
    outputter.annotate_pdf(
      self,
      x: x0 + to_pts(inner_margin_left_mm),
      y: y0 - to_pts(33),                     # y is the top coordinate for Prawn's annotate
      width: inner_width,
      height: barcode_height
    )

    # --- human-readable barcode number (centered under rectangle) --- #
    number_width = width_of(@barcode_no, size: 12, style: :bold)
    x_center = x0 + (barcode_width - number_width) / 2.0
    # place a little below the rectangle (4mm gap)
    draw_text @barcode_no, at: [x_center, y0 - barcode_height - to_pts(10)], size: 12, style: :bold
  end
end
