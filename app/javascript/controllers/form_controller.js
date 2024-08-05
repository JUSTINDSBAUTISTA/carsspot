import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "input"]

  connect() {
    this.currentStep = 0;
    this.showStep(this.currentStep);
    this.loadFormData();
  }

  showStep(step) {
    this.stepTargets.forEach((el, index) => {
      if (index === step) {
        el.classList.add("form-step-active");
      } else {
        el.classList.remove("form-step-active");
      }
    });
  }

  nextStep(event) {
    event.preventDefault();
    if (this.validateStep(this.currentStep)) {
      if (this.currentStep < this.stepTargets.length - 1) {
        this.currentStep++;
        this.showStep(this.currentStep);
      }
    } else {
      alert("Please fill out at least one option in this step.");
    }
  }

  prevStep(event) {
    event.preventDefault();
    if (this.currentStep > 0) {
      this.currentStep--;
      this.showStep(this.currentStep);
    }
  }

  validateStep(step) {
    const stepElement = this.stepTargets[step];
    const inputs = stepElement.querySelectorAll("input, select, textarea");
    return Array.from(inputs).some(input => {
      if (input.type === "checkbox" || input.type === "radio") {
        return input.checked;
      } else {
        return input.value.trim() !== "";
      }
    });
  }

  saveFormData() {
    const formData = {};
    this.inputTargets.forEach(input => {
      formData[input.name] = input.value;
    });
    localStorage.setItem("formData", JSON.stringify(formData));
  }

  loadFormData() {
    const formData = JSON.parse(localStorage.getItem("formData"));
    if (formData) {
      this.inputTargets.forEach(input => {
        if (formData[input.name]) {
          input.value = formData[input.name];
        }
      });
    }
  }
}
