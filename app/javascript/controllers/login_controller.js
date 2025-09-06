import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["toggleLoginButton","customLoginView"]
  connect() {
    //console.log("Trade Analys controller connected.")
  }

  async toggleLogin(event){
    event.preventDefault()
    
    // If you want to use jQuery's animation
    if (typeof jQuery !== 'undefined') {
      $(this.customLoginViewTarget).slideToggle(500)
    } else {
      // Pure JavaScript approach
      if (this.customLoginViewTarget.style.display === "none") {
        this.customLoginViewTarget.style.display = "block"
      } else {
        this.customLoginViewTarget.style.display = "none"
      }
    }
  }
}
