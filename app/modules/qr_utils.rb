module QrUtils
    def get_qr_code(url)
        return RQRCode::QRCode.new(url)
    end

    def abs_url(root_url, relative_url)
        return File.join(root_url + relative_url)
    end

    def get_qr_png(qrcode, size)
        return qrcode.as_png(
            bit_depth: 1,
            border_modules: 1,
            color_mode: ChunkyPNG::COLOR_GRAYSCALE,
            color: "black",
            file: nil,
            fill: "white",
            module_px_size: 6,
            resize_exactly_to: false,
            resize_gte_to: false,
            size: size
            )
    end
end
