function updateFormState(container, adultsDiff, kidsDiff, babiesDiff) {
  const warningContainer = container.querySelector(".js-BookingFormAccommodationAssignmentWarning");
  const submitButton = document.querySelector("input[type='submit']");

  if ((adultsDiff === 0) && (kidsDiff === 0) && (babiesDiff === 0)) {
    warningContainer.setAttribute("hidden", true);
    submitButton.removeAttribute('disabled');
  } else {
    warningContainer.querySelector('.Adults').innerHTML = adultsDiff;
    warningContainer.querySelector('.Kids').innerHTML = kidsDiff;
    warningContainer.querySelector('.Babies').innerHTML = babiesDiff;
    warningContainer.removeAttribute("hidden");
    submitButton.setAttribute('disabled', true);
  }
}

function validateTotalAmount(container) {
  const wrapperContainer = document.querySelector(
    ".js-BookingFormAccommodationAssignment"
  );

  if (document.querySelector('#booking_rooms_count').value === "0") {
    return updateFormState(wrapperContainer, 0, 0, 0);
  }

  const requestedAdultsCount = Number(container.dataset.adultsCount);
  const requestedKidsCount = Number(container.dataset.kidsCount);
  const requestedBabiesCount = Number(container.dataset.babiesCount);
  let currentAdultsCount = 0;
  let currentKidsCount = 0;
  let currentBabiesCount = 0;

  wrapperContainer.querySelectorAll("select[id*='_adults']").forEach(node => {
    const selectedValue = Number(node.value);
    if (Number.isFinite(selectedValue)) {
      currentAdultsCount += selectedValue
    }
  });

  wrapperContainer.querySelectorAll("select[id*='_kids']").forEach(node => {
    const selectedValue = Number(node.value);
    if (Number.isFinite(selectedValue)) {
      currentKidsCount += selectedValue
    }
  })

  wrapperContainer.querySelectorAll("select[id*='_babies']").forEach(node => {
    const selectedValue = Number(node.value);
    if (Number.isFinite(selectedValue)) {
      currentBabiesCount += selectedValue
    }
  })

  updateFormState(
    wrapperContainer,
    requestedAdultsCount - currentAdultsCount,
    requestedKidsCount - currentKidsCount,
    requestedBabiesCount - currentBabiesCount
  );

  return true;
}

function increaseAmount(container, template, amount) {
  while (
    amount >
    container.querySelectorAll(".js-BookingFormAccommodationAssignment-item")
      .length
  ) {
    const newNode = container.insertBefore(
      template.content.firstElementChild.cloneNode(true),
      container.lastChild
    );
    const newIndex =
      container.querySelectorAll(".js-BookingFormAccommodationAssignment-item")
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

    const destroyField = container.querySelector(`#booking_booking_room_assignments_attributes_${newIndex}__destroy`);
    if (destroyField) {
      destroyField.setAttribute('value', false);
    }

    newNode.addEventListener("change", () => {
      validateTotalAmount(container);
    });
  }
}

function decreaseAmount(container, amount) {
  while (
    amount <
    container.querySelectorAll(".js-BookingFormAccommodationAssignment-item")
      .length
  ) {
    const currentIndex = container.querySelectorAll(".js-BookingFormAccommodationAssignment-item").length - 1;

    container.querySelectorAll(".js-BookingFormAccommodationAssignment-item")[currentIndex].remove();

    const destroyField = container.querySelector(`#booking_booking_room_assignments_attributes_${currentIndex}__destroy`);

    if (destroyField) {
      destroyField.setAttribute('value', true);
    }
  }
}

function changeAmount(container, template, amount) {
  const currentAccommodations = container.querySelectorAll(
    ".js-BookingFormAccommodationAssignment-item"
  );
  const currentAmount = currentAccommodations.length;

  if (amount < 1) {
    container
      .closest(".js-BookingFormAccommodationAssignment-accommodations")
      .setAttribute("hidden", true);
  } else {
    container
      .closest(".js-BookingFormAccommodationAssignment-accommodations")
      .removeAttribute("hidden");
  }

  if (amount > currentAmount) {
    increaseAmount(container, template, amount);
  } else if (amount < currentAmount) {
    decreaseAmount(container, amount);
  }

  validateTotalAmount(container);
}

document.addEventListener("turbo:load", () => {
  const accommodationAssignment = document.querySelector(
    ".js-BookingFormAccommodationAssignment"
  );

  if (accommodationAssignment) {
    const template = accommodationAssignment.querySelector(
      ".js-BookingFormAccommodationAssignment-template"
    );
    const select = accommodationAssignment.querySelector(
      ".js-BookingFormAccommodationAssignment-select"
    );
    const container = accommodationAssignment.querySelector(
      ".js-BookingFormAccommodationAssignment-container"
    );
    const assignmentSelects = container.querySelectorAll('select');

    changeAmount(container, template, parseInt(select.value, 10));
    validateTotalAmount(container);

    select.addEventListener("change", e => {
      changeAmount(container, template, parseInt(e.target.value, 10));
    });

    assignmentSelects.forEach(node => {
      node.addEventListener("change", () => {
        validateTotalAmount(container);
      });
    });
  }
});
