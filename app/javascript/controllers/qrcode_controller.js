import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["frontImage", "backImage", "frontCanvas", "backCanvas", "frontVideo", "backVideo", "frontInput", "backInput"];

  connect() {
    this.startCamera("front");
    this.startCamera("back");
  }

  startCamera(side) {
    const input = this[`${side}InputTarget`];
    input.addEventListener('change', () => {
      const file = input.files[0];
      const reader = new FileReader();

      reader.onload = (event) => {
        const img = new Image();
        img.onload = () => {
          const canvas = this[`${side}CanvasTarget`];
          const context = canvas.getContext("2d");
          canvas.width = img.width;
          canvas.height = img.height;
          context.drawImage(img, 0, 0, img.width, img.height);
          const dataURL = canvas.toDataURL("image/png");
          this[`${side}ImageTarget`].value = dataURL;
        };
        img.src = event.target.result;
      };

      if (file) {
        reader.readAsDataURL(file);
      }
    });
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

    const dataURL = canvas.toDataURL("image/png");
    this[`${side}ImageTarget`].value = dataURL;

    this.stopCamera(side);
  }

  stopCamera(side) {
    if (this[`${side}Stream`]) {
      this[`${side}Stream`].getTracks().forEach(track => track.stop());
    }
  }
}
