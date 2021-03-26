import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.animateClasses = (this.data.get('animationClass') || 'hidden').split(' ')

    if (this.data.has("autoClose")) {
      setTimeout(() => this.close(), this.data.get("autoClose"))
    }
  }

  close() {
    if (this.element) {
      this.element.classList.add(...this.animateClasses) // add the animation class to hide elelment from dom
      setTimeout(() => this.element.remove(), 0.5 * 1000) // remove from dom after 1/2 second
    }
  }
}
