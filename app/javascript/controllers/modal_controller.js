// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    console.log("ModalController connected")
  }

  toggleModal() {
    console.log("toggleModal called")
    if (this.hasModalTarget) {
      console.log("Modal target found")
      this.modalTarget.style.display = "block"
    } else {
      console.log("Modal target not found")
    }
  }

  closeModal() {
    console.log("closeModal called")
    if (this.hasModalTarget) {
      console.log("Modal target found")
      this.modalTarget.style.display = "none"
    } else {
      console.log("Modal target not found")
    }
  }
}
