pin "application", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.1/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/lib", under: "lib"

# Add these pins for Bootstrap
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.0/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"

# If you need jQuery
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"

pin "datatables.net", to: "https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"
pin "dataTables.select", to: "https://cdn.datatables.net/select/1.3.3/js/dataTables.select.min.js"

Dir.glob("#{Rails.root}/app/javascript/lib/*.js").each do |file|
  filename = File.basename(file, ".js")
  pin "lib/#{filename}", to: "lib/#{filename}.js"
end


