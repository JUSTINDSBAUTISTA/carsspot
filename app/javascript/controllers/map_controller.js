
import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import process from "process"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    this.initializeMap()
    this.addMarkersToMap()
    this.fitMapToMarkers()
    this.addHoverListeners()
  }

  initializeMap() {
    this.element.innerHTML = "" // Ensure the container is empty

    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v11",
      center: [0, 0],
      zoom: 1
    })

    this.map.addControl(new mapboxgl.NavigationControl())
  }

  addMarkersToMap() {
    this.markersMap = {}

    this.markersValue.forEach((marker) => {
      console.log(`Adding marker for car ${marker.id}`) // Log marker addition
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      const mapMarker = new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)

      this.markersMap[marker.id] = mapMarker
    })
    console.log('All markers:', this.markersMap) // Log all markers
  }

  fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  addHoverListeners() {
    document.querySelectorAll('.car-item').forEach(item => {
      item.addEventListener('mouseenter', (event) => {
        const carId = event.currentTarget.id.replace('car-', '')
        console.log(`Hovering over car ${carId}`)
        this.focusOnMarker(carId)
      })
    })
  }

  focusOnMarker(carId) {
    const marker = this.markersMap[carId]
    if (marker) {
      console.log(`Focusing on marker ${carId}`)
      this.map.flyTo({ center: marker.getLngLat(), zoom: 15 })
      marker.togglePopup()
    } else {
      console.log(`Marker not found for car ${carId}`)
    }
  }
}
