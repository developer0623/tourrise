function increaseAmount(container, template, amount) {
  while (
    amount >
    container.querySelectorAll(".js-BookingFormFlightRequest-item")
      .length
  ) {
    const newNode = container.insertBefore(
      template.content.firstElementChild.cloneNode(true),
      container.lastChild
    );
    const newIndex =
      container.querySelectorAll(".js-BookingFormFlightRequest-item")
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
    container.querySelectorAll(".js-BookingFormFlightRequest-item")
      .length
  ) {
    const currentIndex = container.querySelectorAll(".js-BookingFormFlightRequest-item").length - 1;

    container.querySelectorAll(".js-BookingFormFlightRequest-item")[currentIndex].remove();

    const destroyField = container.querySelector(`#booking_booking_flight_requests_attributes_${currentIndex}__destroy`);

    if (destroyField) {
      destroyField.setAttribute('value', true);
    }
  }
}

function changeAmount(container, template, amount) {
  const currentFlights = container.querySelectorAll(
    ".js-BookingFormFlightRequest-item"
  );
  const currentAmount = currentFlights.length;

  if (amount < 1) {
    container
      .closest(".js-BookingFormFlightRequest-flights")
      .setAttribute("hidden", true);
  } else {
    container
      .closest(".js-BookingFormFlightRequest-flights")
      .removeAttribute("hidden");
  }

  if (amount > currentAmount) {
    increaseAmount(container, template, amount);
  } else if (amount < currentAmount) {
    decreaseAmount(container, amount);
  }
}

document.addEventListener("turbo:load", () => {
  const flightRequest = document.querySelector(
    ".js-BookingFormFlightRequest"
  );

  if (flightRequest) {
    const template = flightRequest.querySelector(
      ".js-BookingFormFlightRequest-template"
    );
    const select = flightRequest.querySelector(
      ".js-BookingFormFlightRequest-select"
    );
    const container = flightRequest.querySelector(
      ".js-BookingFormFlightRequest-container"
    );

    changeAmount(container, template, parseInt(select.value, 10));

    select.addEventListener("change", e => {
      changeAmount(container, template, parseInt(e.target.value, 10));
    });
  }
});
