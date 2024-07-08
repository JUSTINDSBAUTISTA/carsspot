import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = ["startDate", "startTime", "endDate", "endTime"];

  connect() {
    this.initializeDatePickers();
  }

  initializeDatePickers() {
    const today = new Date().toISOString().split("T")[0];

    if (this.hasStartDateTarget) {
      flatpickr(this.startDateTarget, {
        enableTime: false,
        dateFormat: "Y-m-d",
        minDate: today,
        defaultDate: this.startDateTarget.value || today, // Default to today if no value
        onReady: this.applyStyles,
        onChange: this.applyStyles
      });
    }

    if (this.hasStartTimeTarget) {
      flatpickr(this.startTimeTarget, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
        defaultHour: 7,
        defaultMinute: 30,
        defaultDate: this.startTimeTarget.value || null,
        onReady: this.applyStyles,
        onChange: this.applyStyles
      });
    }

    if (this.hasEndDateTarget) {
      flatpickr(this.endDateTarget, {
        enableTime: false,
        dateFormat: "Y-m-d",
        minDate: today,
        defaultDate: this.endDateTarget.value || today, // Default to today if no value
        onReady: this.applyStyles,
        onChange: this.applyStyles
      });
    }

    if (this.hasEndTimeTarget) {
      flatpickr(this.endTimeTarget, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
        defaultHour: 6,
        defaultMinute: 30,
        defaultDate: this.endTimeTarget.value || null,
        onReady: this.applyStyles,
        onChange: this.applyStyles
      });
    }
  }

  applyStyles() {
    // Apply custom styles here if needed
    const datePickers = document.querySelectorAll(".flatpickr-input");
    datePickers.forEach(picker => {
      picker.style.fontSize = "14px"; // Example style change
      picker.style.padding = "5px";
      picker.style.width = "120px"; // Adjust width if necessary
    });
  }
}
