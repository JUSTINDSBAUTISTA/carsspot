import { Controller } from "@hotwired/stimulus";

// Helper function to resize an image
function resizeImage(file, maxWidth, maxHeight, callback) {
  const reader = new FileReader();
  
  reader.onload = function(event) {
    const img = new Image();
    
    img.onload = function() {
      let width = img.width;
      let height = img.height;

      if (width > height) {
        if (width > maxWidth) {
          height *= maxWidth / width;
          width = maxWidth;
        }
      } else {
        if (height > maxHeight) {
          width *= maxHeight / height;
          height = maxHeight;
        }
      }

      const canvas = document.createElement("canvas");
      canvas.width = width;
      canvas.height = height;
      const ctx = canvas.getContext("2d");

      ctx.drawImage(img, 0, 0, width, height);

      canvas.toBlob(callback, "image/jpeg", 0.8);
    };

    img.src = event.target.result;
  };

  reader.readAsDataURL(file);
}

export default class extends Controller {
  static targets = ["drivingLicenseFrontImage", "drivingLicenseBackImage"];

  resizeImage(event) {
    const input = event.target;
    const file = input.files[0];
    const maxWidth = 1024;
    const maxHeight = 768;

    if (file) {
      resizeImage(file, maxWidth, maxHeight, (blob) => {
        const resizedFile = new File([blob], file.name, { type: "image/jpeg", lastModified: Date.now() });
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(resizedFile);
        input.files = dataTransfer.files;
      });
    }
  }
}
