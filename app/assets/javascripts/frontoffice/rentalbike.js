function increaseAmount(container, template, amount) {
  while (
    amount >
    container.querySelectorAll(".js-BookingFormRentalbikeRequest-item")
      .length
  ) {
    const newNode = container.insertBefore(
      template.content.firstElementChild.cloneNode(true),
      container.lastChild
    );
    const newIndex =
      container.querySelectorAll(".js-BookingFormRentalbikeRequest-item")
        .length - 1;

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

function decreaseAmount(container, amount) {
  while (
    amount <
    container.querySelectorAll(".js-BookingFormRentalbikeRequest-item")
      .length
  ) {
    container.querySelector(".js-BookingFormRentalbikeRequest-item:last-of-type")
      .remove();
  }
}

function changeAmount(container, template, amount) {
  const currentRentalbikes = container.querySelectorAll(
    ".js-BookingFormRentalbikeRequest-item"
  );
  const currentAmount = currentRentalbikes.length;

  if (amount < 1) {
    container
      .closest(".js-BookingFormRentalbikeRequest-rentalbikes")
      .setAttribute("hidden", true);
  } else {
    container
      .closest(".js-BookingFormRentalbikeRequest-rentalbikes")
      .removeAttribute("hidden");
  }

  if (amount > currentAmount) {
    increaseAmount(container, template, amount);
  } else if (amount < currentAmount) {
    decreaseAmount(container, amount);
  }
}

document.addEventListener("turbo:load", () => {
  const rentalbikeRequest = document.querySelector(
    ".js-BookingFormRentalbikeRequest"
  );

  if (rentalbikeRequest) {
    const template = rentalbikeRequest.querySelector(
      ".js-BookingFormRentalbikeRequest-template"
    );
    const select = rentalbikeRequest.querySelector(
      ".js-BookingFormRentalbikeRequest-select"
    );
    const container = rentalbikeRequest.querySelector(
      ".js-BookingFormRentalbikeRequest-container"
    );

    changeAmount(container, template, parseInt(select.value, 10));

    select.addEventListener("change", e => {
      changeAmount(container, template, parseInt(e.target.value, 10));
    });
  }
});
