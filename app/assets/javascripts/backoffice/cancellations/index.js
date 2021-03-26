document.addEventListener("turbo:load", () => {
  document.querySelectorAll('.CancellationButton').forEach(item => {
    const modal = item.parentNode.querySelector(".CancellationModal");
    const cancellationForm = modal.querySelector(".CancellationForm");
    const closeSign = modal.getElementsByClassName("close")[0];

    function anyRadioButtonChecked(form) {
      const submitButton = form.querySelector("input[type=submit]");
      const checkedRadioButtons = form.querySelector(".CancellationReason input[type=radio]:checked")

      if (checkedRadioButtons.size > 0) {
        submitButton.disabled = false
      } else {
        submitButton.disabled = true
      }
    }

    item.addEventListener('click', event => {
      event.preventDefault();

      modal.style.display = "block";
    })

    closeSign.addEventListener('click', () => {
      modal.style.display = "none";
    })

    cancellationForm.addEventListener('change', () => {
      anyRadioButtonChecked(cancellationForm);
    }, false)

    window.addEventListener('click', event => {
      if (event.target === modal) {
        modal.style.display = "none";
      }
    })
  })
})
