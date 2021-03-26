function addResourceSkuPricing(template, clickedElement) {
  const container = clickedElement
    .closest(".js-ResourceSkuForm-resourceSkuPricingsSection")
    .querySelector(".js-ResourceSkuForm-resourceSkuPricingsContainer");

  const newNode = container.insertBefore(
    template.content.firstElementChild.cloneNode(true),
    container.lastChild
  );

  const newIndex =
    document.querySelectorAll(
      ".js-ResourceSkuForm-resourceSkuPricingsContainer .js-ResourceSkuForm-newResourceSkuPricing"
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

function removeResourceSkuPricing(clickedElement) {
  const container = clickedElement.closest(
    ".js-ResourceSkuForm-newResourceSkuPricing"
  );

  container.remove();
}

function formVisibility (text) {
  const form = document.querySelector(".js-newConsecutiveDaysForm");

  if (text === 'consecutive_days') {
    form.style.display = 'flex';
  } else {
    form.style.display = 'none';
  }
}

function consecutiveDaysEventVisibility(e) {
  const text = e.target.value;

  formVisibility(text);
}

function consecutiveDaysVisibility() {
  const calculationType = document.getElementById('resource_sku_pricing_calculation_type')

  if (calculationType) {
    const text = calculationType.value

    formVisibility(text);
  }
}

document.addEventListener("turbo:load", () => {
  const resourceEditForm = document.querySelector(".js-ResourceSkuForm");
  const calculationType = document.getElementById('resource_sku_pricing_calculation_type')

  consecutiveDaysVisibility();

  if (calculationType) { calculationType.addEventListener("change", consecutiveDaysEventVisibility) }

  if (resourceEditForm) {
    const template = document.querySelector(
      ".js-ResourceSkuForm-newResourceSkuPricingTemplate"
    );

    resourceEditForm.addEventListener("click", e => {
      const clickedElement = e.target;
      const newResourceSkuPricingButton = clickedElement.closest(
        ".js-ResourceSkuForm-newResourceSkuPricingButton"
      );
      const removeResourceSkuPricingButton = clickedElement.closest(
        ".js-ResourceSkuPricingForm-removeResourceSkuPricingButton"
      );

      if (newResourceSkuPricingButton) {
        e.preventDefault();
        addResourceSkuPricing(template, newResourceSkuPricingButton);
      } else if (removeResourceSkuPricingButton) {
        e.preventDefault();
        removeResourceSkuPricing(removeResourceSkuPricingButton);
      }
    });
  }
});
