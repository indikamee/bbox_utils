namespace :barcodes do
    desc "Generate PDFs with barcodes from a CSV"
    task generate: :environment do
        require "csv"


        csv_path   = Rails.root.join("tmp/VariableData.csv")
        output_dir = Rails.root.join("tmp/barcodes")

        FileUtils.mkdir_p(output_dir)

        CSV.foreach(csv_path, headers: true) do |row|
            name        = row["Variable1"]    # Cat No
            description = row["Variable2"] #row["Description"]  # Add this column in CSV if you want text at top-right

            number      = row["BC_Unit"]      # Barcode number
            pdf_path = File.join(output_dir, "#{name}-#{description} - BC LABEL UP FA(OL)v1.01.pdf")
            pdf = BarcodePdf.new(number,name,description)
            pdf.render_file pdf_path
            puts "Generated UNIT: #{pdf_path}"

            number      = row["BC_Inner"]      # Barcode number
            pdf_path = File.join(output_dir, "#{name}-#{description} - BC LABEL INNER FA(OL)v1.01.pdf")
            pdf = BarcodePdf.new(number,name,description)
            pdf.render_file pdf_path
            puts "Generated UNIT: #{pdf_path}"

            number      = row["BC_Outer"]      # Barcode number
            pdf_path = File.join(output_dir, "#{name}-#{description} - BC LABEL OUTER FA(OL)v1.01.pdf")
            pdf = BarcodePdf.new(number,name,description)
            pdf.render_file pdf_path
            puts "Generated UNIT: #{pdf_path}"
        end
    end


end
