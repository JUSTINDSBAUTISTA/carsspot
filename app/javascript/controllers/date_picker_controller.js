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
        defaultDate: this.startDateTarget.value || today,
        onChange: (selectedDates) => {
          this.showTimePicker("pickup");
          if (this.hasEndDateTarget) {
            this.endDatePicker.set("minDate", selectedDates[0] || today);
            const selectedDate = selectedDates[0] || new Date();
            const selectedMonth = selectedDate.getMonth();
            const selectedYear = selectedDate.getFullYear();

            const currentEndDate = new Date(this.endDateTarget.value || today);
            const currentEndMonth = currentEndDate.getMonth();
            const currentEndYear = currentEndDate.getFullYear();

            if (selectedMonth !== currentEndMonth || selectedYear !== currentEndYear) {
              const nextMonthDate = new Date(selectedYear, selectedMonth + 1, 1);
              this.endDatePicker.setDate(nextMonthDate, false);
            }
          }
        }
      });
    }

    if (this.hasStartTimeTarget) {
      flatpickr(this.startTimeTarget, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
        defaultHour: 7,
        defaultMinute: 30,
        onChange: (selectedDates, dateStr) => {
          this.setDefaultReturnTime(dateStr);
          this.validateEndTime();
        }
      });
    }

    if (this.hasEndDateTarget) {
      this.endDatePicker = flatpickr(this.endDateTarget, {
        enableTime: false,
        dateFormat: "Y-m-d",
        minDate: today,
        defaultDate: this.endDateTarget.value || today,
        onChange: () => {
          this.showTimePicker("return");
          this.validateEndTime();
        }
      });
    }

    if (this.hasEndTimeTarget) {
      flatpickr(this.endTimeTarget, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
        defaultHour: 8,
        defaultMinute: 30,
        onChange: () => {
          this.validateEndTime();
        }
      });
    }
  }

  showTimePicker(type) {
    const timeWrapper = document.getElementById(`${type}-time-wrapper`);
    if (timeWrapper) {
      timeWrapper.style.display = "flex";
    }
  }

  setDefaultReturnTime(pickupTimeStr) {
    const [pickupHour, pickupMinute] = pickupTimeStr.split(":").map(Number);
    let returnHour = pickupHour + 1;
    let returnMinute = pickupMinute;

    if (returnHour >= 24) {
      returnHour -= 24;
    }

    const returnTimeStr = `${returnHour.toString().padStart(2, "0")}:${returnMinute.toString().padStart(2, "0")}`;
    this.endTimeTarget.value = returnTimeStr;
  }

  validateEndTime() {
    const pickupDate = this.parseDate(this.startDateTarget.value);
    const returnDate = this.parseDate(this.endDateTarget.value);
    const pickupTime = this.startTimeTarget.value;
    const returnTime = this.endTimeTarget.value;

    if (pickupDate && returnDate && pickupTime && returnTime) {
      if (pickupDate.toISOString().split("T")[0] === returnDate.toISOString().split("T")[0]) {
        const [pickupHours, pickupMinutes] = pickupTime.split(":").map(Number);
        const [returnHours, returnMinutes] = returnTime.split(":").map(Number);

        const pickupDateTime = new Date(pickupDate);
        pickupDateTime.setHours(pickupHours, pickupMinutes);

        const returnDateTime = new Date(returnDate);
        returnDateTime.setHours(returnHours, returnMinutes);

        if (returnDateTime < pickupDateTime) {
          this.setDefaultReturnTime(pickupTime);
        }
      }
    }
  }

  parseDate(dateStr) {
    if (!dateStr) return null;
    const date = new Date(dateStr);
    return isNaN(date) ? null : date;
  }
}
