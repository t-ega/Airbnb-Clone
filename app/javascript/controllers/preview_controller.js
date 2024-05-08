import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  update(event) {
    const input = event.target
    const preview = document.getElementById('property-preview')

    if (input.files && input.files[0]) {
      const reader = new FileReader()
      reader.onload = function (e) {
        preview.src = e.target.result
        preview.style.display = 'block'
      }
      reader.readAsDataURL(input.files[0])
    } else {
      preview.src = '#'
      preview.style.display = 'none'
    }
  }
}
