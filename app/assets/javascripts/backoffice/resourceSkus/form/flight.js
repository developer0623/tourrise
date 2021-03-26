import initializeFlatpickr from '../../../shared/date_picker';

function addFlight(template, clickedElement) {
  const container = clickedElement
    .closest(".js-ResourceSkuForm-flightsSection")
    .querySelector(".js-ResourceSkuForm-flightsContainer");

  const newNode = container.insertBefore(
    template.content.firstElementChild.cloneNode(true),
    container.lastChild
  );

  const newIndex =
    document.querySelectorAll(
      ".js-ResourceSkuForm-flightsContainer .js-ResourceSkuForm-newFlight"
    ).length - 1;

  Array.from(newNode.querySelectorAll("label, input")).forEach(element => {
    const el = element;

    if (el.tagName === "LABEL") {
      const newVal = el.getAttribute("for").replace("_ID_", `_${newIndex}_`);
      el.setAttribute("for", newVal);
    } else {
      el.id = el.id.replace("_ID_", `_${newIndex}_`);
      el.name = el.name.replace("[ID]", `[${newIndex}]`);
    }
  });
  initializeFlatpickr();
}

function removeFlight(clickedElement) {
  const container = clickedElement.closest(
    ".js-ResourceSkuForm-newFlight"
  );

  container.remove();
}

document.addEventListener("turbo:load", () => {
  const resourceEditForm = document.querySelector(".js-ResourceSkuForm");

  if (resourceEditForm) {
   const template = document.querySelector(
     ".js-ResourceSkuForm-newFlightTemplate"
   );

   resourceEditForm.addEventListener("click", e => {
     const clickedElement = e.target;
     const newFlightButton = clickedElement.closest(
       ".js-ResourceSkuForm-newFlightButton"
     );
     const removeFlightButton = clickedElement.closest(
       ".js-FlightForm-removeFlightButton"
     );

     if (newFlightButton) {
       e.preventDefault();
       addFlight(template, newFlightButton);
     } else if (removeFlightButton) {
       e.preventDefault();
       removeFlight(removeFlightButton);
     }
   });
  }
});
