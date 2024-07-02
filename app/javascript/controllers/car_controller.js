import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.modal = document.getElementById('filters-modal')
  }

  toggle() {
    this.modal.style.display = "block"
  }

  close() {
    this.modal.style.display = "none"
  }

  applyFilters() {
    // Get filter values
    const instantBooking = document.getElementById('instant-booking').checked
    const numberOfPlaces = document.getElementById('number-of-places').value
    const recentCars = document.getElementById('recent-cars').checked

    // Construct filter query params
    const params = new URLSearchParams()
    if (instantBooking) params.append('instant_booking', instantBooking)
    if (numberOfPlaces) params.append('number_of_places', numberOfPlaces)
    if (recentCars) params.append('recent_cars', recentCars)

    // Redirect with filter params
    window.location.search = params.toString()

    // Close modal
    this.close()
  }

  toggleMoreEquipment() {
    // Logic to toggle more equipment
  }
}
