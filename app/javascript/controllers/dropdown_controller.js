// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "vehicleTypeButton"]

  connect() {
    this.selectedTypes = []
    this.initializeSelectedTypes()
  }

  toggleDropdown() {
    this.dropdownTarget.classList.toggle("show")
  }

  selectType(event) {
    const button = event.currentTarget
    const type = button.getAttribute("data-type")
    if (this.selectedTypes.includes(type)) {
      this.selectedTypes = this.selectedTypes.filter(t => t !== type)
      button.classList.remove('selected')
    } else {
      this.selectedTypes.push(type)
      button.classList.add('selected')
    }
  }

  applyTypes() {
    const params = new URLSearchParams(window.location.search)
    params.set('car_types', this.selectedTypes.join(','))
    window.location.search = params.toString()
  }

  resetFilters() {
    this.selectedTypes = []
    this.vehicleTypeButtonTargets.forEach(button => {
      button.classList.remove('selected')
    })
    const params = new URLSearchParams(window.location.search)
    params.delete('car_types')
    window.history.replaceState({}, document.title, `${window.location.pathname}?${params.toString()}`)
  }

  initializeSelectedTypes() {
    const params = new URLSearchParams(window.location.search)
    if (params.has('car_types')) {
      this.selectedTypes = params.get('car_types').split(',')
      this.selectedTypes.forEach(type => {
        const button = this.vehicleTypeButtonTargets.find(btn => btn.getAttribute("data-type") === type)
        if (button) {
          button.classList.add('selected')
        }
      })
    }
  }
}
