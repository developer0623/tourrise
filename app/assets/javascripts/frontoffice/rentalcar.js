function increaseAmount(container, template, amount) {
  while (
    amount >
    container.querySelectorAll(".js-BookingFormRentalcarRequest-item")
      .length
  ) {
    const newNode = container.insertBefore(
      template.content.firstElementChild.cloneNode(true),
      container.lastChild
    );
    const newIndex =
      container.querySelectorAll(".js-BookingFormRentalcarRequest-item")
        .length - 1;

    const destroyInput = container.querySelector(`input[id*="${newIndex}__destroy"]`);

    if (destroyInput) {
      destroyInput.setAttribute('value', false);
    }

    Array.from(newNode.querySelectorAll("label, select, input")).forEach(
      element => {
        const el = element;

        if (el.tagName === "LABEL") {
          const newVal = el.getAttribute("for").replace("_0_", `_${newIndex}_`);
          el.setAttribute("for", newVal);
        } else {
          el.id = el.id.replace("_0_", `_${newIndex}_`);
          el.name = el.name.replace("[0]", `[${newIndex}]`);
        }
      }
    );
  }
}

function decreaseAmount(container, amount, currentAmount) {
  for (let i = amount; i < currentAmount; i += 1) {

    container.querySelector(".js-BookingFormRentalcarRequest-item:last-of-type")
      .remove();

    const destroyInput = container.querySelector(`input[id*="${i}__destroy"]`);

    if (destroyInput) {
      destroyInput.setAttribute('value', true);

    }

  }
}

function changeAmount(container, template, amount) {
  const currentRentalcars = container.querySelectorAll(
    ".js-BookingFormRentalcarRequest-item"
  );
  const currentAmount = currentRentalcars.length;

  if (amount < 1) {
    container
      .closest(".js-BookingFormRentalcarRequest-rentalcars")
      .setAttribute("hidden", true);
  } else {
    container
      .closest(".js-BookingFormRentalcarRequest-rentalcars")
      .removeAttribute("hidden");
  }

  if (amount > currentAmount) {
    increaseAmount(container, template, amount);
  } else if (amount < currentAmount) {
    decreaseAmount(container, amount, currentAmount);
  }
}

document.addEventListener("turbo:load", () => {
  const rentalcarRequest = document.querySelector(
    ".js-BookingFormRentalcarRequest"
  );

  if (rentalcarRequest) {
    const template = rentalcarRequest.querySelector(
      ".js-BookingFormRentalcarRequest-template"
    );
    const select = rentalcarRequest.querySelector(
      ".js-BookingFormRentalcarRequest-select"
    );
    const container = rentalcarRequest.querySelector(
      ".js-BookingFormRentalcarRequest-container"
    );

    changeAmount(container, template, parseInt(select.value, 10));

    select.addEventListener("change", e => {
      changeAmount(container, template, parseInt(e.target.value, 10));
    });
  }
});
