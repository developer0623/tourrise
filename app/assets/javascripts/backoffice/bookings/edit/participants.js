import { refreshIcons } from "../../../shared/utils";

document.addEventListener("turbo:load", () => {
  const bookingEditForm = document.querySelector(".js-BookingEditForm");
  const participantAddedEvent = new CustomEvent("participantAdded", { bubbles: true });

  function addParticipant(template, clickedElement) {
    const container = clickedElement
      .closest(".js-BookingEditForm-newParticipantContainer")
      .querySelector(".js-BookingEditForm-newParticipant");

    const newNode = container.parentNode.insertBefore(
      template.content.firstElementChild.cloneNode(true),
      container.parentNode.lastChild
    );

    const newIndex =
      document.querySelectorAll(
        ".js-BookingEditForm-newParticipantContainer .js-BookingEditForm-newParticipant"
      ).length - 1;

    Array.from(newNode.querySelectorAll("label, input, select")).forEach(
      (el) => {
        const element = el;

        if (element.tagName === "LABEL") {
          const newVal = element
            .getAttribute("for")
            .replace("_ID_", `_${newIndex}_`);
          element.setAttribute("for", newVal);
        } else {
          element.id = element.id.replace("_ID_", `_${newIndex}_`);
          element.name = element.name.replace("[ID]", `[${newIndex}]`);
        }
      }
    );

    refreshIcons(newNode);

    newNode.dispatchEvent(participantAddedEvent);
  }

  function removeParticipant(clickedElement) {
    const container = clickedElement.closest(
      ".js-BookingEditForm-newParticipant"
    );

    container.remove();
  }

  if (bookingEditForm) {
    bookingEditForm.addEventListener("click", (e) => {
      const clickedElement = e.target;

      const template = document.querySelector(
        ".js-BookingEditForm-newParticipantTemplate"
      );
      const newParticipantButton = clickedElement.closest(
        ".js-BookingEditForm-newParticipantButton"
      );
      const removeParticipantButton = clickedElement.closest(
        ".js-BookingEditForm-removeParticipantButton"
      );

      if (newParticipantButton) {
        e.preventDefault();
        addParticipant(template, newParticipantButton);
      } else if (removeParticipantButton) {
        e.preventDefault();
        removeParticipant(removeParticipantButton);
      }
    });
  }
});
