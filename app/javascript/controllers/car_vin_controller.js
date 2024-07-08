import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["vin", "carName", "carBrand", "vinConfirm", "transmission", "fuelType", "numberOfDoors"];

  fetchVinData() {
    const vin = this.vinTarget.value;
    if (vin.length === 17) {
      fetch(`/cars/confirm_vin?vin=${vin}`)
        .then(response => response.json())
        .then(data => {
          console.log("Fetched VIN data:", data);
          this.carNameTarget.value = data.car_name || "Not available";
          this.carBrandTarget.value = data.car_brand || "Not available";
          this.transmissionTarget.value = data.transmission || "Not available";
          this.fuelTypeTarget.value = data.fuel_type || "Not available";
          this.numberOfDoorsTarget.value = data.number_of_doors || "Not available";
          this.vinConfirmTarget.value = vin;
          alert("VIN confirmed. Please proceed.");
        })
        .catch(error => {
          console.error("Error fetching VIN data:", error);
        });
    }
  }

  confirmCarDetails(event) {
    event.preventDefault();
    const vin = this.vinTarget.value;
    const carName = this.carNameTarget.value;
    const carBrand = this.carBrandTarget.value;
    this.vinConfirmTarget.value = vin; // Ensure VIN is set

    alert(`Car details confirmed:\n\nVIN: ${vin}\nCar Name: ${carName}\nCar Brand: ${carBrand}`);

    // Proceed to the next step
    this.nextStep();
  }

  nextStep() {
    const currentStep = this.element.querySelector(".form-step-active");
    const nextStep = currentStep.nextElementSibling;
    if (nextStep && nextStep.classList.contains("form-step")) {
      currentStep.classList.remove("form-step-active");
      nextStep.classList.add("form-step-active");
    }
  }

  prevStep() {
    const currentStep = this.element.querySelector(".form-step-active");
    const prevStep = currentStep.previousElementSibling;
    if (prevStep && prevStep.classList.contains("form-step")) {
      currentStep.classList.remove("form-step-active");
      prevStep.classList.add("form-step-active");
    }
  }
}
