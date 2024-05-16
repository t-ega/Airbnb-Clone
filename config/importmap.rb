# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "air-datepicker", to: "https://ga.jspm.io/npm:air-datepicker@3.5.0/index.es.js" # @3.5.0
pin "toastr", to: "https://ga.jspm.io/npm:toastr@2.1.4/toastr.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
