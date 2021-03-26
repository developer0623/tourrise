document.addEventListener("click", event => {
  if (event.target.classList.contains('js-editSecondaryState')) {
    event.preventDefault();

    const secondaryStateControlEl = document.querySelector(".js-secondaryStateControl");

    if (secondaryStateControlEl) {
      const showSection = secondaryStateControlEl.querySelector(".js-secondaryStateShowSection");
      const editSection = secondaryStateControlEl.querySelector(".js-secondaryStateEditSection");
      const selectField = secondaryStateControlEl.querySelector(".js-secondaryStateField");

      showSection.classList.add("u-hidden");
      editSection.classList.remove("u-hidden");

      if (selectField) selectField.focus();
    }
  }
}, false)
