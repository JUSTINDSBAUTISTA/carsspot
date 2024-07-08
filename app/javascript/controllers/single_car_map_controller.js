import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    apiKey: String,
    latitude: Number,
    longitude: Number
  }

  connect() {
    this.initializeMap()
    if (this.hasLatitudeValue && this.hasLongitudeValue) {
      this.addSingleMarkerToMap()
    } else {
      console.log("No coordinates to display")
    }
  }

  initializeMap() {
    this.element.innerHTML = ""

    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v11",
      center: [this.longitudeValue, this.latitudeValue],
      zoom: 15
    })

    this.map.addControl(new mapboxgl.NavigationControl())
  }

  addSingleMarkerToMap() {
    const el = document.createElement('div')
    el.className = 'custom-marker'
    el.style.backgroundImage = 'url(https://cdn4.iconfinder.com/data/icons/map-pins-2/256/13-1024.png)'
    el.style.width = '50px'
    el.style.height = '50px'
    el.style.backgroundSize = 'cover'

    new mapboxgl.Marker(el)
      .setLngLat([this.longitudeValue, this.latitudeValue])
      .addTo(this.map)

    this.map.flyTo({ center: [this.longitudeValue, this.latitudeValue], zoom: 15 })
  }
}
