create_file 'app/javascript/controllers/notice_controller.js', <<~JAVASCRIPT
  import { Controller } from "@hotwired/stimulus";

  export default class extends Controller {
    connect() {
      const notices = document.querySelector("#notices");
      if (notices) {
        setTimeout(() => {
          notices.style.display = "none";
        }, 3000);
      }
    }
  }
JAVASCRIPT

create_file 'app/javascript/controllers/popup_controller.js', <<~JAVASCRIPT
  import { Controller } from "@hotwired/stimulus";

  export default class extends Controller {
    show(event) {
      event.preventDefault();

      const id = event.currentTarget.dataset.id;
      document.querySelector(`#${id}`).classList.remove("hidden");
    }

    hide(event) {
      event.preventDefault();
      const id = event.currentTarget.dataset.id;
      document.querySelector(`#${id}`).classList.add("hidden");
    }
  }
JAVASCRIPT
