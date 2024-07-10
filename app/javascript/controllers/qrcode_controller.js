import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["reader", "startCameraButton", "stopCameraButton", "drivingLicenseFrontImage", "drivingLicenseBackImage"];

  connect() {
    console.log("QRCode controller connected");
  }

  startCamera(event) {
    event.preventDefault();

    this.readerTarget.style.display = 'block';
    this.startCameraButtonTarget.style.display = 'none';
    this.stopCameraButtonTarget.style.display = 'block';

    this.html5QrCode = new Html5Qrcode(this.readerTarget.id);

    this.html5QrCode.start(
      { facingMode: "environment" }, // Use the rear camera
      {
        fps: 10,    // Frame-per-second
        qrbox: 250  // Optional, if you want bounded box UI
      },
      (decodedText, decodedResult) => {
        // Handle the result here
        console.log(`Scan result: ${decodedText}`);
        // Example: Set the value to the input field
        this.drivingLicenseFrontImageTarget.value = decodedText; // Or any other action you need
        this.html5QrCode.stop().then(() => {
          console.log("QR Code scanning stopped.");
          this.readerTarget.style.display = 'none';
          this.startCameraButtonTarget.style.display = 'block';
          this.stopCameraButtonTarget.style.display = 'none';
        }).catch((err) => {
          console.error("Unable to stop scanning.", err);
        });
      },
      (errorMessage) => {
        // Parse the error message
        console.error(`Error scanning: ${errorMessage}`);
      }
    ).catch((err) => {
      console.error(`Error starting camera: ${err}`);
    });
  }

  stopCamera(event) {
    event.preventDefault();

    if (this.html5QrCode) {
      this.html5QrCode.stop().then(() => {
        console.log("QR Code scanning stopped.");
        this.readerTarget.style.display = 'none';
        this.startCameraButtonTarget.style.display = 'block';
        this.stopCameraButtonTarget.style.display = 'none';
      }).catch((err) => {
        console.error("Unable to stop scanning.", err);
      });
    }
  }
}
