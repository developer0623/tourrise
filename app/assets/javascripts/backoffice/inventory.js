function updateAvailabilityForms(container, selectField) {
  const { value } = selectField;

  if (value === 'quantity') {
    container.querySelectorAll('.js-AvailabilityForm-quantityInput').forEach(input => input.removeAttribute('hidden'));
    container.querySelectorAll('.js-AvailabilityForm-dateRangeInput').forEach(input => input.setAttribute('hidden', true));
  }

  if (value === 'quantity_in_date_range') {
    container.querySelectorAll('.js-AvailabilityForm-quantityInput').forEach(input => input.removeAttribute('hidden'));
    container.querySelectorAll('.js-AvailabilityForm-dateRangeInput').forEach(input => input.removeAttribute('hidden'));
  }
}

function initializeInventoryForm(container, inventoryTypeSelectField) {
  inventoryTypeSelectField.addEventListener('change', e => {
    e.preventDefault();
    updateAvailabilityForms(container, inventoryTypeSelectField);
  });

  updateAvailabilityForms(container, inventoryTypeSelectField);
}

function addAvailability(template, clickedElement) {
  const container = clickedElement
    .closest(".js-InventoryForm-newAvailabilityContainer")
    .querySelector(".js-InventoryForm-newAvailability");

  const newNode = container.parentNode.insertBefore(
    template.content.firstElementChild.cloneNode(true),
    container.parentNode.lastChild
  );

  const newIndex =
    document.querySelectorAll(
      ".js-InventoryForm-newAvailabilityContainer .js-InventoryForm-newAvailability"
    ).length - 1;

  Array.from(newNode.querySelectorAll("label, input, select")).forEach(element => {
    const el = element;

    if (el.tagName === "LABEL") {
      const newVal = el.getAttribute("for").replace("_ID_", `_${newIndex}_`);
      el.setAttribute("for", newVal);
    } else {
      el.id = el.id.replace("_ID_", `_${newIndex}_`);
      el.name = el.name.replace("[ID]", `[${newIndex}]`);
    }
  });
}

function removeAvailability(clickedElement) {
  const container = clickedElement.closest(
    ".js-InventoryForm-newAvailability"
  );

  container.remove();
}

document.addEventListener("turbo:load", () => {
  const inventoryForm = document.querySelector(".js-InventoryForm");

  if (inventoryForm) {
    const inventoryTypeSelectField = inventoryForm.querySelector('.js-InventoryForm-inventoryTypeSelect');

    const template = document.querySelector(
      ".js-InventoryForm-newAvailabilityTemplate"
    );

    initializeInventoryForm(inventoryForm, inventoryTypeSelectField);

    inventoryForm.addEventListener("click", e => {
      const clickedElement = e.target;
      const newAvailabilityButton = clickedElement.closest(
        ".js-InventoryForm-newAvailabilityButton"
      );
      const removeAvailabilityButton = clickedElement.closest(
        ".js-InventoryForm-removeAvailabilityButton"
      );

      if (newAvailabilityButton) {
        e.preventDefault();
        addAvailability(template, newAvailabilityButton);
        updateAvailabilityForms(inventoryForm, inventoryTypeSelectField);
      }

      if (removeAvailabilityButton) {
        e.preventDefault();
        removeAvailability(removeAvailabilityButton);
      }
    });
  }
});
