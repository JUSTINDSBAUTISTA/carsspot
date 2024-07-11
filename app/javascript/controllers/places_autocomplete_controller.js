import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["homeInput", "formInput", "indexInput"];

  connect() {
    this.loadGoogleMapsAPI().then(() => {
      this.initializeAutocomplete();
    }).catch(error => {
      console.error('Error loading Google Maps API:', error);
    });
  }

  loadGoogleMapsAPI() {
    return new Promise((resolve, reject) => {
      if (window.google && window.google.maps) {
        resolve();
      } else {
        if (document.querySelector('script[src*="maps.googleapis.com"]')) {
          window.initAutocomplete = resolve;
        } else {
          const apiKey = document.querySelector('meta[name="google-api-key"]').content;
          if (!apiKey) {
            reject("Google API key is missing");
            return;
          }

          window.initAutocomplete = () => {
            resolve();
          };

          const script = document.createElement('script');
          script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&libraries=places&callback=initAutocomplete&loading=async`;
          script.async = true;
          script.defer = true;
          script.onerror = () => reject('Error loading Google Maps API');
          document.head.appendChild(script);
        }
      }
    });
  }

  initializeAutocomplete() {
    if (!window.google || !window.google.maps) {
      console.error("Google Maps API not loaded");
      return;
    }

    this.autocompleteService = new google.maps.places.AutocompleteService();
    this.placesService = new google.maps.places.PlacesService(document.createElement('div'));

    if (this.hasHomeInputTarget) {
      this.setupAutocomplete(this.homeInputTarget, "home");
    }

    if (this.hasFormInputTarget) {
      this.setupAutocomplete(this.formInputTarget, "form");
    }

    if (this.hasIndexInputTarget) {
      this.setupAutocomplete(this.indexInputTarget, "index");
    }
  }

  setupAutocomplete(inputTarget, key) {
    const autocomplete = new google.maps.places.Autocomplete(inputTarget, { types: ['geocode'] });

    autocomplete.addListener('place_changed', () => {
      const place = autocomplete.getPlace();
      if (place.geometry) {
        console.log('Latitude:', place.geometry.location.lat());
        console.log('Longitude:', place.geometry.location.lng());
      }
    });

    inputTarget.addEventListener('input', () => {
      const input = inputTarget.value;
      if (!input) {
        this.clearSuggestions(key);
        return;
      }
      this.autocompleteService.getPlacePredictions({ input }, this.displaySuggestions.bind(this, key));
    });

    inputTarget.addEventListener('focus', () => {
      this.clearSuggestions(key);
    });

    if (key !== "home") {
      inputTarget.addEventListener('keydown', (event) => {
        if (event.key === 'Enter') {
          event.preventDefault();
          this.search(inputTarget);
        }
      });
    }

    this.addCurrentLocation(inputTarget, key);
  }

  displaySuggestions(key, predictions, status) {
    if (status !== google.maps.places.PlacesServiceStatus.OK || !predictions) {
      return;
    }

    const suggestionContainer = this.createSuggestionContainer(key);
    if (!suggestionContainer) {
      console.error(`Element with id '${key}-autocomplete-suggestions' not found.`);
      return;
    }
    suggestionContainer.innerHTML = ''; // Clear previous suggestions

    predictions.forEach(prediction => {
      const suggestionItem = document.createElement('div');
      suggestionItem.classList.add('custom-autocomplete-item');
      suggestionItem.innerHTML = `<i class="fas fa-map-marker-alt custom-autocomplete-icon"></i> ${prediction.description}`;
      suggestionItem.addEventListener('click', () => {
        this[`${key}InputTarget`].value = prediction.description;
        this.selectPlace(key, prediction.place_id);
        this.clearSuggestions(key);
        if (key === "index") {
          this.search(this[`${key}InputTarget`]);
        }
      });
      suggestionContainer.appendChild(suggestionItem);
    });
  }


  addCurrentLocation(inputTarget, key) {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const lat = position.coords.latitude;
          const lng = position.coords.longitude;
          const suggestionContainer = this.createSuggestionContainer(key);
          const currentLocationItem = document.createElement('div');
          currentLocationItem.classList.add('custom-autocomplete-item');
          currentLocationItem.innerHTML = `<i class="fas fa-map-marker-alt custom-autocomplete-icon"></i> Current Location`;
          currentLocationItem.addEventListener('click', () => {
            this.setCurrentLocation(lat, lng, inputTarget);
          });
          suggestionContainer.prepend(currentLocationItem);
        },
        (error) => {
          console.error("Error getting current location: ", error);
        }
      );
    }
  }

  setCurrentLocation(lat, lng, inputTarget) {
    const geocoder = new google.maps.Geocoder();
    const latlng = { lat, lng };
    geocoder.geocode({ location: latlng }, (results, status) => {
      if (status === 'OK') {
        if (results[0]) {
          inputTarget.value = results[0].formatted_address;
        } else {
          console.error('No results found');
        }
      } else {
        console.error('Geocoder failed due to: ' + status);
      }
    });
  }

  clearSuggestions(key) {
    const suggestionContainer = document.getElementById(`${key}-autocomplete-suggestions`);
    if (suggestionContainer) {
      suggestionContainer.innerHTML = '';
    }
  }

  search(inputTarget) {
    const location = inputTarget.value;
    window.location.href = `/cars?location=${encodeURIComponent(location)}`;
  }
}
