class BarcodeController < ApplicationController
    require "csv"
    require 'zip'

    def index
        
    end

    def generate_labels
        if params[:csv_file].present?
            csv = CSV.parse(params[:csv_file].read, headers: true)
            label_files = []
            csv.each_with_index do |row, idx|
                # Generate label PDF for each row (implement your logic here)
                label_files += generate_label_pdf(row)
            end
            zip_stream = Zip::OutputStream.write_buffer do |zip|
                label_files.each do |filename, pdf_data|
                    zip.put_next_entry(filename)
                    zip.write(pdf_data)
                end
            end
            zip_stream.rewind
            csv_filename = params[:csv_file].original_filename
            zip_filename = "#{File.basename(csv_filename, File.extname(csv_filename))}.zip"
            send_data zip_stream.read, filename: zip_filename, type: "application/zip", disposition: 'attachment'
        else
            redirect_to barcode_index_path, alert: "Please upload a CSV file."
        end
    end

    private
    def generate_label_pdf(row)
        name        = row["Variable1"]    # Cat No
        description = row["Variable2"] #row["Description"]  # Add this column in CSV if you want text at top-right

        files = []

        number      = row["BC_Unit"]      # Barcode number
        filename = "#{name}-#{description} - BC LABEL UP FA(OL)v1.01.pdf"
        pdf = BarcodePdf.new(number,name,description)
        pdf_data = pdf.render
        puts "Generated UNIT: #{filename}"
        files << [filename, pdf_data]

        number      = row["BC_Inner"]      # Barcode number
        filename = "#{name}-#{description} - BC LABEL INNER FA(OL)v1.01.pdf"
        pdf = BarcodePdf.new(number,name,description)
        pdf_data = pdf.render
        puts "Generated INNER: #{filename}"
        files << [filename, pdf_data]

        number      = row["BC_Outer"]      # Barcode number
        filename = "#{name}-#{description} - BC LABEL OUTER FA(OL)v1.01.pdf"
        pdf = BarcodePdf.new(number,name,description)
        pdf_data = pdf.render
        puts "Generated OUTER: #{filename}"      
        files << [filename, pdf_data]

        files
    end
end