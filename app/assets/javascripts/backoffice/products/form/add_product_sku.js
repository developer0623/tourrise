function addProductSku(template, clickedElement) {
  const container = clickedElement
    .closest(".js-ProductForm-addProductSkusContainer")
    .querySelector(".js-ProductForm-addProductSku");
  const newNode = container.parentNode.insertBefore(
    template.content.firstElementChild.cloneNode(true),
    container.parentNode.lastChild
  );

  const newIndex =
    document.querySelectorAll(
      ".js-ProductForm-addProductSkusContainer .js-ProductForm-addProductSku"
    ).length - 1;

  Array.from(newNode.querySelectorAll("label, input")).forEach(element => {
    const el = element;

    if (el.tagName === "LABEL") {
      const newVal = el.getAttribute("for").replace("__ID__", `_${newIndex}_`);
      el.setAttribute("for", newVal);
    } else {
      el.id = el.id.replace("__ID__", `_${newIndex}_`);
      el.name = el.name.replace("[%ID%]", `[${newIndex}]`);
    }
  });
}

function displayMultiProductSkuSection(container, clickedElement) {
  const singleVariantInput = container.querySelector('.js-ProductForm-singleProductSkuInput');
  const multipleVariantInput = container.querySelector('.js-ProductForm-addProductSkusContainer');

  if (clickedElement.checked) {
    singleVariantInput.querySelector('input').setAttribute('disabled', true);
    singleVariantInput.setAttribute('hidden', true);

    multipleVariantInput.removeAttribute('hidden');
    multipleVariantInput.querySelectorAll('input').forEach(input => input.removeAttribute('disabled'));
  } else {
    singleVariantInput.removeAttribute('hidden');
    singleVariantInput.querySelector('input').removeAttribute('disabled');

    multipleVariantInput.querySelectorAll('input').forEach(input => input.setAttribute('disabled', true));
    multipleVariantInput.setAttribute('hidden', true);
  }
}

function initializeProductSkuSection(productForm) {
  const template = document.querySelector(
    ".js-ProductForm-addProductSkuTemplate"
  );

  productForm.addEventListener("click", e => {
    const clickedElement = e.target;
    const addProductSkuButton = clickedElement.closest(
      ".js-ProductForm-addProductSkuButton"
    );
    const multipleProductSkusInput = clickedElement.closest(
      ".js-ProductFormMultipleSkusCheckBox"
    );

    if (addProductSkuButton) {
      e.preventDefault();
      addProductSku(template, addProductSkuButton);
    }

    if (multipleProductSkusInput) {
      displayMultiProductSkuSection(productForm, multipleProductSkusInput);
    }
  });

  displayMultiProductSkuSection(productForm, productForm.querySelector('.js-ProductFormMultipleSkusCheckBox'));
}

document.addEventListener("turbo:load", () => {
  const productForm = document.querySelector(".js-ProductForm");

  if (productForm) {
    initializeProductSkuSection(productForm);
  }
});
