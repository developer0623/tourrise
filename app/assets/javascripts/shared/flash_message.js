document.addEventListener("turbo:load", () => {
  document.addEventListener("click", event => {
    if (event.target.classList.contains("js-FlashMessage-close")) {
      event.preventDefault();
      event.target.closest(".js-FlashMessage").remove();
    }
  });
});
