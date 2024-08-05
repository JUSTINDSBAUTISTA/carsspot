import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["vin", "carName", "carBrand", "transmission", "fuelType", "fuelTypeSecondary", "numberOfDoors", "engineHp", "driveType", "bodyClass", "carType", "modelYear", "vinConfirm", "airBagLocCurtain", "airBagLocFront", "airBagLocSide", "engineCylinders", "engineManufacturer", "engineModel", "gvwr", "plantCity", "plantCountry", "series", "tpms", "vehicleType"];

  fetchVinData() {
    const vin = this.vinTarget.value;
    if (vin.length === 17) {
      fetch(`/cars/confirm_vin?vin=${vin}`)
        .then(response => response.json())
        .then(data => {
          console.log("Fetched VIN data:", data);
          this.updateField(this.carNameTarget, data.car_name);
          this.updateField(this.carBrandTarget, data.car_brand);
          this.updateField(this.transmissionTarget, data.transmission);
          this.updateField(this.fuelTypeTarget, data.fuel_type);
          this.updateField(this.fuelTypeSecondaryTarget, data.fuel_type_secondary);
          this.updateField(this.numberOfDoorsTarget, data.number_of_doors);
          this.updateField(this.engineHpTarget, data.engine_hp);
          this.updateField(this.driveTypeTarget, data.drive_type);
          this.updateField(this.bodyClassTarget, data.body_class);
          this.updateCarType(data.body_class);
          this.updateField(this.modelYearTarget, data.model_year);
          this.updateField(this.airBagLocCurtainTarget, data.air_bag_loc_curtain);
          this.updateField(this.airBagLocFrontTarget, data.air_bag_loc_front);
          this.updateField(this.airBagLocSideTarget, data.air_bag_loc_side);
          this.updateField(this.engineCylindersTarget, data.engine_cylinders);
          this.updateField(this.engineManufacturerTarget, data.engine_manufacturer);
          this.updateField(this.engineModelTarget, data.engine_model);
          this.updateField(this.gvwrTarget, data.gvwr);
          this.updateField(this.plantCityTarget, data.plant_city);
          this.updateField(this.plantCountryTarget, data.plant_country);
          this.updateField(this.seriesTarget, data.series);
          this.updateField(this.tpmsTarget, data.tpms);
          this.updateField(this.vehicleTypeTarget, data.vehicle_type);
          this.vinConfirmTarget.value = vin;
          alert("VIN confirmed. Please proceed.");
        })
        .catch(error => {
          console.error("Error fetching VIN data:", error);
        });
    }
  }

  updateField(target, value) {
    if (value && value !== "Not available") {
      target.closest('.form-group').style.display = 'block';
      target.value = value;
    } else {
      target.closest('.form-group').style.display = 'none';
    }
  }

  updateCarType(bodyClass) {
    const carTypeMap = {
      'Convertible/Cabriolet': 'Convertible',
      'Sedan': 'Sedan',
      'SUV': 'SUV',
      'Truck': 'Truck',
      'Coupe': 'Coupe'
    };
    const carType = carTypeMap[bodyClass] || '';
    if (carType) {
      const options = Array.from(this.carTypeTarget.options);
      const optionToSelect = options.find(option => option.value === carType);
      if (optionToSelect) {
        optionToSelect.selected = true;
      }
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
