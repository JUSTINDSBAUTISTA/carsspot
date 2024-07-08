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
    if (this.markersValue.length > 0) {
      this.addMarkersToMap()
      this.fitMapToMarkers()
    } else {
      console.log("No markers to display")
    }
    this.addHoverListeners()
  }

  initializeMap() {
    this.element.innerHTML = ""

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
      if (marker.lng && marker.lat) {  // Ensure marker has valid lng and lat
        console.log(`Adding marker for car ${marker.id}`) // Log marker addition
        const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

        // Create a custom marker element
        const el = document.createElement('div')
        el.className = 'custom-marker'
        el.style.backgroundImage = 'url(https://cdn4.iconfinder.com/data/icons/map-pins-2/256/13-1024.png)'
        el.style.width = '50px'
        el.style.height = '50px'
        el.style.backgroundSize = 'cover'

        const mapMarker = new mapboxgl.Marker(el)
          .setLngLat([marker.lng, marker.lat])
          .setPopup(popup)
          .addTo(this.map)

        // Add click event to open location in Google Maps
        mapMarker.getElement().addEventListener('click', () => {
          const googleMapsUrl = `https://www.google.com/maps/search/?api=1&query=${marker.lat},${marker.lng}`
          window.open(googleMapsUrl, '_blank')
        })

        this.markersMap[marker.id] = mapMarker
      } else {
        console.log(`Skipping marker for car ${marker.id} due to invalid coordinates`)
      }
    })
    console.log('All markers:', this.markersMap) // Log all markers
  }

  fitMapToMarkers() {
    if (this.markersValue.length === 0) {
      console.log("No markers to fit bounds to")
      return // Do nothing if there are no markers
    }

    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => {
      if (marker.lng && marker.lat) { // Ensure marker has valid lng and lat
        bounds.extend([marker.lng, marker.lat])
      }
    })
    
    if (bounds.isEmpty()) {
      console.log("Bounds are empty, not fitting map")
      return // Prevent fitting map to empty bounds
    }
    
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
