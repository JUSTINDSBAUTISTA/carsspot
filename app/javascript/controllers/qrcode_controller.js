import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["frontImage", "backImage", "frontCanvas", "backCanvas", "frontVideo", "backVideo"];

  connect() {
    this.startCamera("front");
    this.startCamera("back");
  }

  startCamera(side) {
    navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } })
      .then(stream => {
        this[`${side}VideoTarget`].srcObject = stream;
        this[`${side}Stream`] = stream;
      })
      .catch(error => console.error("Error accessing the camera: ", error));
  }

  captureFrontImage() {
    this.captureImage("front");
  }

  captureBackImage() {
    this.captureImage("back");
  }

  captureImage(side) {
    const video = this[`${side}VideoTarget`];
    const canvas = this[`${side}CanvasTarget`];
    const context = canvas.getContext("2d");
    
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    context.drawImage(video, 0, 0, canvas.width, canvas.height);

    // Convert the canvas to a data URL and set it as the value of the hidden input field
    const dataURL = canvas.toDataURL("image/png");
    this[`${side}ImageTarget`].value = dataURL;

    // Stop the camera
    this.stopCamera(side);
  }

  stopCamera(side) {
    if (this[`${side}Stream`]) {
      this[`${side}Stream`].getTracks().forEach(track => track.stop());
    }
  }
}
