// app/javascript/controllers/car_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.resetCarTypesOnLoad()
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("show")
    }
  }

  toggle() {
    this.menuTarget.classList.toggle("show")
  }

  selectType(event) {
    event.currentTarget.classList.toggle("selected")
  }

  resetTypes() {
    this.menuTarget.querySelectorAll('.selected').forEach(el => {
      el.classList.remove('selected')
    })
  }

  applyTypes() {
    const selectedTypes = Array.from(this.menuTarget.querySelectorAll('.selected'))
      .map(el => el.dataset.type)

    const params = new URLSearchParams(window.location.search)
    params.set('car_types', selectedTypes.join(','))
    window.location.search = params.toString()
  }

  resetFilters() {
    console.log("Reset button clicked"); // Debug log
    this.resetTypes()
    const params = new URLSearchParams(window.location.search)
    params.delete('car_types')
    window.history.replaceState({}, document.title, `${window.location.pathname}?${params.toString()}`)

    // Remove filter effect from the car listing
    this.clearCarFilters()
  }

  resetCarTypesOnLoad() {
    const params = new URLSearchParams(window.location.search)
    if (params.has('car_types')) {
      params.delete('car_types')
      window.history.replaceState({}, document.title, `${window.location.pathname}?${params.toString()}`)
    }
  }

  clearCarFilters() {
    fetch(`${window.location.pathname}?${new URLSearchParams(window.location.search)}`)
      .then(response => response.text())
      .then(html => {
        // Replace the car list content with the unfiltered content
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const newCarsContainer = doc.querySelector('.cars-container');
        document.querySelector('.cars-container').innerHTML = newCarsContainer.innerHTML;
      })
  }
}
