document.addEventListener("click", event => {
  if (event.target.classList.contains('js-editDueOn')) {
    event.preventDefault();

    const dueOnControl = event.target.closest(".js-dueOnControl");

    if (dueOnControl) {
      const dueOnEditSection = dueOnControl.querySelector(".js-dueOnEditSection");
      const dueOnShowSection = dueOnControl.querySelector(".js-dueOnShowSection");
      const dueOnField = dueOnControl.querySelector(".js-dueOnField");

      dueOnShowSection.classList.add("u-hidden");
      dueOnEditSection.classList.remove("u-hidden");

      if (dueOnField) dueOnField.focus();
    }
  }
}, false)
