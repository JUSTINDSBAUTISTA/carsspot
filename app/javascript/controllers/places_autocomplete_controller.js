import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="places-autocomplete"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    const apiKey = document.querySelector('meta[name="google-api-key"]');
    if (!apiKey) {
      console.error("Google API key is missing");
      return;
    }
    const script = document.createElement('script');
    script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey.content}&libraries=places&callback=initAutocomplete`;
    script.async = true;
    script.defer = true;
    document.head.appendChild(script);

    window.initAutocomplete = this.initializeAutocomplete.bind(this);
  }

  initializeAutocomplete() {
    this.autocomplete = new google.maps.places.Autocomplete(this.inputTarget, { types: ['geocode'] });

    this.autocomplete.addListener('place_changed', () => {
      const place = this.autocomplete.getPlace();
      if (place.geometry) {
        console.log('Latitude:', place.geometry.location.lat());
        console.log('Longitude:', place.geometry.location.lng());
      }
    });

    this.inputTarget.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault(); // Prevent form submission on Enter
      }
    });
  }
}
