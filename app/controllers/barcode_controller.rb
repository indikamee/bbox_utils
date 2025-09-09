class BarcodeController < ApplicationController
    require "csv"
    require 'zip'

    def index
        
    end

    def generate_labels
        if params[:csv_file].present?
            # Get checkbox values (default to true if not present)
            unit_selected  = params[:unit] == "1"
            inner_selected = params[:inner] == "1"
            outer_selected = params[:outer] == "1"

            csv = CSV.parse(params[:csv_file].read, headers: true)
            label_files = []
            csv.each_with_index do |row, idx|
                # Pass checkbox selections to PDF generation
                label_files += generate_label_pdf(row, unit_selected, inner_selected, outer_selected)
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
    def generate_label_pdf(row, unit_selected, inner_selected, outer_selected)
        name        = row["Name"]    # Cat No
        description = row["Description"]

        files = []

        if unit_selected
            number      = row["BC_Unit"]
            filename = "#{name}-#{description} - BC LABEL UP FA(OL)v1.01.pdf"
            pdf = BarcodePdf.new(number,name,description)
            pdf_data = pdf.render
            puts "Generated UNIT: #{filename}"
            files << [filename, pdf_data]
        end

        if inner_selected
            number      = row["BC_Inner"]
            filename = "#{name}-#{description} - BC LABEL INNER FA(OL)v1.01.pdf"
            pdf = BarcodePdf.new(number,name,description)
            pdf_data = pdf.render
            puts "Generated INNER: #{filename}"
            files << [filename, pdf_data]
        end

        if outer_selected
            number      = row["BC_Outer"]
            filename = "#{name}-#{description} - BC LABEL OUTER FA(OL)v1.01.pdf"
            pdf = BarcodePdf.new(number,name,description)
            pdf_data = pdf.render
            puts "Generated OUTER: #{filename}"      
            files << [filename, pdf_data]
        end

        files
    end
end