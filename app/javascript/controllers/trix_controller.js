import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.initializeTrix();
  }

  initializeTrix() {
    document.querySelectorAll("trix-editor").forEach((editor) => {
      if (!editor.dataset.initialized) {
        editor.dataset.initialized = true; // Prevent multiple initializations
        editor.dispatchEvent(new Event("trix-initialize"));
      }
    });
  }
}
