import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "toggleButton"]

  connect() {
    console.log("ModalController connected")
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
  }

  toggleModal(event) {
    event.preventDefault() // Prevent form submission
    console.log("toggleModal called")
    if (this.hasModalTarget) {
      console.log("Modal target found")
      this.modalTarget.classList.add("show-modal")
      document.addEventListener("click", this.handleOutsideClick)
    } else {
      console.log("Modal target not found")
    }
  }

  closeModal(event) {
    event.preventDefault() // Prevent form submission
    console.log("closeModal called")
    if (this.hasModalTarget) {
      console.log("Modal target found")
      this.modalTarget.classList.remove("show-modal")
      document.removeEventListener("click", this.handleOutsideClick)
    } else {
      console.log("Modal target not found")
    }
  }

  handleOutsideClick(event) {
    console.log("Handle outside click called")
    console.log("Event target:", event.target)
    console.log("Modal target:", this.modalTarget)

    if (this.modalTarget && !this.modalTarget.contains(event.target) && !this.element.contains(event.target)) {
      this.closeModal(event)
    } else {
      console.log("Click was inside the modal or the element")
    }
  }

  toggleButton(event) {
    event.preventDefault()
    const button = event.currentTarget
    button.classList.toggle("selected")
  }
}
