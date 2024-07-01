# config/importmap.rb
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin_all_from "app/javascript/channels", under: "channels"
pin "jquery", to: "jquery.min.js", preload: true

pin "@rails/actioncable", to: "actioncable.esm.js"
pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@3.1.2/dist/mapbox-gl.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"

# Ensure you pin the CSS for mapbox-gl as well
pin "mapbox-gl/dist/mapbox-gl.css", to: "https://api.mapbox.com/mapbox-gl-js/v2.8.2/mapbox-gl.css"
pin "@rails/ujs", to: "rails-ujs.js", preload: true
pin "@mapbox/mapbox-gl-geocoder", to: "https://ga.jspm.io/npm:@mapbox/mapbox-gl-geocoder@5.0.0/lib/index.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.9/dist/flatpickr.js"
