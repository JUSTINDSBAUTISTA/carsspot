import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static targets = ["startDate", "startTime", "endDate", "endTime"]

  connect() {
    console.log("Date picker controller connected")
    console.log("Flatpickr:", flatpickr)

    this.initializeDatePickers()
  }

  initializeDatePickers() {
    console.log("Initializing date pickers on:", this.startDateTarget, this.startTimeTarget, this.endDateTarget, this.endTimeTarget)

    flatpickr(this.startDateTarget, {
      enableTime: false,
      dateFormat: "D, M j"
    })

    flatpickr(this.startTimeTarget, {
      enableTime: true,
      noCalendar: true,
      dateFormat: "h:i K",
      time_24hr: false,
      defaultHour: 7,
      defaultMinute: 30
    })

    flatpickr(this.endDateTarget, {
      enableTime: false,
      dateFormat: "D, M j"
    })

    flatpickr(this.endTimeTarget, {
      enableTime: true,
      noCalendar: true,
      dateFormat: "h:i K",
      time_24hr: false,
      defaultHour: 6,
      defaultMinute: 30
    })
  }
}
