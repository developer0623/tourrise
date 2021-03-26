function addResourceSku(template, clickedElement) {
  const container = clickedElement
    .closest(".js-ResourceForm-newResourceSkuContainer")
    .querySelector(".js-ResourceForm-newResourceSku");

  const newNode = container.parentNode.insertBefore(
    template.content.firstElementChild.cloneNode(true),
    container.parentNode.lastChild
  );

  const newIndex =
    document.querySelectorAll(
      ".js-ResourceForm-newResourceSkuContainer .js-ResourceForm-newResourceSku"
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
}

function removeResourceSku(clickedElement) {
  const container = clickedElement.closest(
    ".js-ResourceForm-newResourceSku"
  );

  container.remove();
}

document.addEventListener("turbo:load", () => {
  const resourceEditForm = document.querySelector(".js-ResourceForm");

  if (resourceEditForm) {
    const template = document.querySelector(
      ".js-ResourceForm-newResourceSkuTemplate"
    );

    resourceEditForm.addEventListener("click", e => {
      const clickedElement = e.target;
      const newResourceSkuButton = clickedElement.closest(
        ".js-ResourceForm-newResourceSkuButton"
      );
      const removeResourceSkuButton = clickedElement.closest(
        ".js-ResourceForm-removeResourceSkuButton"
      );

      if (newResourceSkuButton) {
        e.preventDefault();
        addResourceSku(template, newResourceSkuButton);
      } else if (removeResourceSkuButton) {
        e.preventDefault();
        removeResourceSku(removeResourceSkuButton);
      }
    });
  }
});
